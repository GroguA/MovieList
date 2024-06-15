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
    func dislikeMovie(at index: Int)
    func likeMovie(at index: Int)
    func updateMovies(completion: (([MovieModel]) -> Void))
    func fetchMoviesByQuery(_ query: String, completion: @escaping (Result<[MovieModel], Error>) -> Void)
    func searchStopped()
}

final class MovieListInteractor {
    
    private var currentPage = 1
    
    private var moviesBeforeSearchStarted = [MovieModel]()
    
    private var isSearching = false
    
    private var searchedMovies = [MovieModel]()
    
    private let serviceLocator = ServiceLocator.shared
    
}

extension MovieListInteractor: IMovieListInteractor {
    func fetchMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        serviceLocator.networkService.getPopularMovies(page: currentPage) { result in
            switch result {
            case .success(let movies):
                let mappedMovies = self.mapMoviesSchemeToMovieModels(movies).unique()
                self.moviesBeforeSearchStarted = mappedMovies
                completion(.success(self.moviesBeforeSearchStarted))
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
                self.moviesBeforeSearchStarted += newMovies
                completion(.success(self.moviesBeforeSearchStarted))
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
                let mappedMovies = self.mapMoviesSchemeToMovieModels(movies).unique()
                completion(.success(mappedMovies))
                self.searchedMovies = mappedMovies
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func dislikeMovie(at index: Int) {
        let movie: MovieModel
        
        if isSearching {
            searchedMovies[index].isMovieFavorite = false
            movie = searchedMovies[index]
        } else {
            movie = moviesBeforeSearchStarted[index]
            moviesBeforeSearchStarted[index].isMovieFavorite = false
        }
        do {
            try serviceLocator.favoriteMoviesService.removeMovieFromFavorites(movieId: movie.id)
        } catch {
            
        }
    }
    
    func likeMovie(at index: Int) {
        let movie: MovieModel
        
        if isSearching {
            searchedMovies[index].isMovieFavorite = true
            movie = searchedMovies[index]
        } else {
            moviesBeforeSearchStarted[index].isMovieFavorite = true
            movie = moviesBeforeSearchStarted[index]
        }
        
        let coreDataModel = FavoriteMovieCoreDataModel(
            id: movie.id,
            title: movie.title,
            pathToImage: movie.pathToImage
        )
        
        do {
            try serviceLocator.favoriteMoviesService.addMovieToFavorites(movieToAdd: coreDataModel)
        } catch {
            
        }
    }
    
    func updateMovies(completion: (([MovieModel]) -> Void)) {
        if isSearching {
            completion(searchedMovies)
        } else {
            completion(moviesBeforeSearchStarted)
        }
    }
    
    func searchStopped() {
        isSearching = false
    }
}

private extension MovieListInteractor {
    func mapMoviesSchemeToMovieModels(_ movies: [MovieScheme]) -> [MovieModel] {
        let pathToImage = "https://image.tmdb.org/t/p/w500"
        return movies.compactMap { movieScheme in
            guard let posterPath = movieScheme.posterPath else {
                return nil
            }
            return MovieModel(
                id: movieScheme.id,
                title: movieScheme.title,
                pathToImage: pathToImage + posterPath,
                isMovieFavorite: false,
                likeIconPath: "heart",
                dislikeIconPath: "heart.fill"
            )
        }
    }
    
}
