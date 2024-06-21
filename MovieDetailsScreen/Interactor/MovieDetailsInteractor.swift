//
//  MovieDetailsInteractor.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import Foundation

protocol IMovieDetailsInteractor {
    func fetchMovieDetails(completion: @escaping (Result<MovieDetailsModel, Error>) -> Void)
}

final class MovieDetailsInteractor {
    private let serviceLocator = ServiceLocator.shared
    private let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
}

extension MovieDetailsInteractor: IMovieDetailsInteractor {
    func fetchMovieDetails(completion: @escaping (Result<MovieDetailsModel, Error>) -> Void) {
        serviceLocator.networkService.getMovieDetailsById(movieId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movie):
                let mappedMovie = self.mapMovieSchemeToMovieModel(movie)
                completion(.success(mappedMovie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension MovieDetailsInteractor {
    func mapMovieSchemeToMovieModel(_ movie: MovieDetailsResponseScheme) -> MovieDetailsModel {
        let favoriteMovies = (try? serviceLocator.favoriteMoviesService.fetchFavoriteMovies()) ?? []
        let isMovieFavorite = favoriteMovies.contains { $0.id == movie.id }
        let budgetText: String
        
        if movie.budget == 0 {
            budgetText = "not stated"
        } else {
            budgetText = "\(movie.budget.formatted())  $"
        }
        
        let genres = movie.genres.map { $0.name }.joined(separator: ", ")
        let pathToImage = movie.backdropPath.map { "https://image.tmdb.org/t/p/w500" + $0 }
        let favoriteMovieText = isMovieFavorite ? "That movie is your favorite one" : "That movie is not your favorite"
        let formattedPopularity = String(format: "%.2f", (movie.popularity / 1000))
        
        return MovieDetailsModel(
            budget: budgetText,
            originalLanguage: movie.originalLanguage,
            releaseDate: movie.releaseDate,
            status: movie.status,
            popularity: formattedPopularity,
            navigationItemTitle: movie.title,
            genre: genres,
            pathToImage: pathToImage,
            isMovieFavorite: favoriteMovieText
        )
    }
}


