//
//  Interactor.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import Foundation

protocol IMovieListInteractor {
    func fetchMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void)
    func loadMoreMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void)
    func dislikeMovie(at index: Int, completion: (([MovieModel]) -> Void)) throws
    func likeMovie(at index: Int, completion: (([MovieModel]) -> Void)) throws
    func fetchMoviesByQuery(_ query: String, completion: @escaping (Result<[MovieModel], Error>) -> Void)
    func searchStopped(completion: (([MovieModel]) -> Void))
    func movieDeletedFromFavorite(_ deletedMovie: FavoriteMovieModel, completion: (([MovieModel]) -> Void))
}

final class MovieListInteractor {
    private var currentMovies = [MovieModel]()
    private var currentPage = 1
    private var moviesBeforeSearchStarted = [MovieModel]()
    private var isSearching = false
    private let serviceLocator = ServiceLocator.shared
    
}

extension MovieListInteractor: IMovieListInteractor {
    func fetchMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        serviceLocator.networkService.getPopularMovies(page: currentPage) { [weak self] result in
            self?.currentPage = 1
            guard let self else { return }
            switch result {
            case .success(let movies):
                let mappedMovies = self.mapMoviesSchemeToMoviesModel(movies)
                self.moviesBeforeSearchStarted = mappedMovies
                self.currentMovies = mappedMovies
                completion(.success(mappedMovies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadMoreMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        if isSearching {
            return
        }
        currentPage += 1
        serviceLocator.networkService.getPopularMovies(page: currentPage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movies):
                let newMovies = self.mapMoviesSchemeToMoviesModel(movies)
                let mergedMovies = self.currentMovies + newMovies
                self.currentMovies = mergedMovies
                self.moviesBeforeSearchStarted = mergedMovies
                completion(.success(mergedMovies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMoviesByQuery(_ query: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        if query.isEmpty {
            return
        }
        isSearching = true
        serviceLocator.networkService.searchMovieByQuery(query) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movies):
                let mappedMovies = self.mapMoviesSchemeToMoviesModel(movies)
                self.currentMovies = mappedMovies
                completion(.success(mappedMovies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func dislikeMovie(at index: Int, completion: (([MovieModel]) -> Void)) throws {
        let updatedMovie: MovieModel
        let movie = currentMovies[index]
        updatedMovie = movie.copyWith(isMovieFavorite: false)
        currentMovies[index] = updatedMovie
        updateIsMovieFavorite(updatedMovie)
        
        completion(currentMovies)
        
        try serviceLocator.favoriteMoviesService.removeMovieFromFavorites(by: movie.id)
    }
    
    func likeMovie(at index: Int, completion: (([MovieModel]) -> Void)) throws {
        let updatedMovie: MovieModel
        let movie = currentMovies[index]
        updatedMovie = movie.copyWith(isMovieFavorite: true)
        currentMovies[index] = updatedMovie
        updateIsMovieFavorite(updatedMovie)
        
        completion(currentMovies)
        
        let coreDataModel = FavoriteMovieCoreDataModel(
            id: movie.id,
            title: movie.title,
            pathToImage: movie.pathToImage
        )
        
        try serviceLocator.favoriteMoviesService.addMovieToFavorites(coreDataModel)
    }
    
    func searchStopped(completion: (([MovieModel]) -> Void)) {
        isSearching = false
        currentMovies = moviesBeforeSearchStarted
        completion(currentMovies)
    }
    
    func movieDeletedFromFavorite(_ deletedMovie: FavoriteMovieModel, completion: (([MovieModel]) -> Void)) {
        updateFavoriteStatus(for: deletedMovie, in: &currentMovies)
        if isSearching {
            updateFavoriteStatus(for: deletedMovie, in: &moviesBeforeSearchStarted)
        }
        completion(currentMovies)
    }
    
}

private extension MovieListInteractor {
    func mapMoviesSchemeToMoviesModel(_ movies: [MovieScheme]) -> [MovieModel] {
        let pathToImage = "https://image.tmdb.org/t/p/w500"
        var favoriteMovies = [FavoriteMovieCoreDataModel]()
        
        do {
            favoriteMovies = try serviceLocator.favoriteMoviesService.fetchFavoriteMovies()
        } catch {
            favoriteMovies = []
        }
        
        var mappedMovies = [MovieModel]()
        movies.forEach { movieScheme in
            let isMovieFavorite = favoriteMovies.contains(where: { movieScheme.id == $0.id } )
            guard let posterPath = movieScheme.posterPath else { return }
            let mappedMovie = MovieModel(
                id: movieScheme.id,
                title: movieScheme.title,
                pathToImage: pathToImage + posterPath,
                isMovieFavorite: isMovieFavorite,
                likeIconPath: "heart",
                dislikeIconPath: "heart.fill"
            )
            mappedMovies.append(mappedMovie)
        }
        return mappedMovies
    }
    
    func updateIsMovieFavorite(_ movie: MovieModel) {
        guard let index = moviesBeforeSearchStarted.firstIndex(where: { $0.id == movie.id })  else { return }
            moviesBeforeSearchStarted[index] = movie
    }
    
    private func updateFavoriteStatus(for deletedMovie: FavoriteMovieModel, in moviesArray: inout [MovieModel]) {
        if let index = moviesArray.firstIndex(where: { $0.id == deletedMovie.id }) {
            let movie = moviesArray[index]
            let newMovie = movie.copyWith(isMovieFavorite: false)
            moviesArray[index] = newMovie
        }
    }
}
