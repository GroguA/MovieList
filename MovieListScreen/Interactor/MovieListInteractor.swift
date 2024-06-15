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

}

final class MovieListInteractor {
            
    private var currentPage = 1
    
    private var moviesBeforeSearchStarted: [MovieModel] = [MovieModel]()
    
    private let networkService = MovieNetworkService()
    
}

extension MovieListInteractor: IMovieListInteractor {
    func fetchMovies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        networkService.getPopularMovies(page: currentPage) { result in
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
        currentPage += 1
        networkService.getPopularMovies(page: currentPage) { result in
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
    
    func dislikeMovie(at index: Int) {
        moviesBeforeSearchStarted[index].isMovieFavorite = false
    }
    
    func likeMovie(at index: Int) {
        moviesBeforeSearchStarted[index].isMovieFavorite = true
    }
    
    func updateMovies(completion: (([MovieModel]) -> Void)) {
        completion(moviesBeforeSearchStarted)
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
