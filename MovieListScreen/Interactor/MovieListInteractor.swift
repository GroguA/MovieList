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
    func dislikeMovie(at index: Int) throws
    func likeMovie(at index: Int) throws
    func fetchMoviesByQuery(_ query: String, completion: @escaping (Result<[MovieModel], Error>) -> Void)
    func searchStopped()
    func updateMovies(completion: (([MovieModel]) -> Void))
}

final class MovieListInteractor {
    
    var currentMovies = [MovieModel]()
    
    private var currentPage = 1
    
    private var moviesBeforeSearchStarted = [MovieModel]()
    
    private var isSearching = false
    
    private let serviceLocator = ServiceLocator.shared
    
}

extension MovieListInteractor: IMovieListInteractor {
    func fetchMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        serviceLocator.networkService.getPopularMovies(page: currentPage) { result in
            switch result {
            case .success(let movies):
                let mappedMovies = self.mapMoviesSchemeToMovieModels(movies).unique()
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
        serviceLocator.networkService.getPopularMovies(page: currentPage) { result in
            switch result {
            case .success(let movies):
                let newMovies = self.mapMoviesSchemeToMovieModels(movies).unique()
                let mergedMovies = self.moviesBeforeSearchStarted + newMovies
                self.currentMovies = mergedMovies
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
        serviceLocator.networkService.searchMovieByQuery(query) { result in
            switch result {
            case .success(let movies):
                let mappedMovies = self.mapMoviesSchemeToMovieModels(movies)
                self.currentMovies = mappedMovies
                completion(.success(mappedMovies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func dislikeMovie(at index: Int) throws {
        let updatedMovie: MovieModel
        let movie = currentMovies[index]
            updatedMovie = movie.copyWith(isMovieFavorite: false)
            currentMovies[index] = updatedMovie
            updateIsMovieFavorite(updatedMovie)

        try serviceLocator.favoriteMoviesService.removeMovieFromFavorites(movieId: movie.id)
    }

    func likeMovie(at index: Int) throws {
        let updatedMovie: MovieModel
            let movie = currentMovies[index]
            updatedMovie = movie.copyWith(isMovieFavorite: true)
            currentMovies[index] = updatedMovie
            updateIsMovieFavorite(updatedMovie)
        
        let coreDataModel = FavoriteMovieCoreDataModel(
            id: movie.id,
            title: movie.title,
            pathToImage: movie.pathToImage
        )
        
        try serviceLocator.favoriteMoviesService.addMovieToFavorites(movieToAdd: coreDataModel)
    }

    func searchStopped() {
        isSearching = false
        currentMovies = moviesBeforeSearchStarted
    }
    
    func updateMovies(completion: (([MovieModel]) -> Void)) {
        completion(currentMovies)
    }

}

private extension MovieListInteractor {
    private func mapMoviesSchemeToMovieModels(_ movies: [MovieScheme]) -> [MovieModel] {
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
    
    private func updateIsMovieFavorite(_ movie: MovieModel) {
        if let index = moviesBeforeSearchStarted.firstIndex(where: { $0.id == movie.id }) {
            moviesBeforeSearchStarted[index] = movie
        }
    }
    
}
