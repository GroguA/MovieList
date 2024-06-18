//
//  FavoriteMoviesInteractor.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import Foundation

protocol IFavoriteMoviesInteractor {
    func loadFavoriteMovies(completion: @escaping ([FavoriteMovieModel]) -> Void)
    func deleteMovie(by id: Int) throws
    
}

final class FavoriteMoviesInteractor {
    private let serviceLocator = ServiceLocator.shared
    
}

extension FavoriteMoviesInteractor: IFavoriteMoviesInteractor {
    func loadFavoriteMovies(
        completion: @escaping ([FavoriteMovieModel]) -> Void
    ) {
            var favoriteMappedMovieModels = [FavoriteMovieModel]()
            do {
                let favoriteMovies = try serviceLocator.favoriteMoviesService.fetchFavoriteMovies()
                
                favoriteMappedMovieModels = favoriteMovies.map { movie in
                    return FavoriteMovieModel(
                        id: movie.id,
                        pathToImage: movie.pathToImage,
                        title: movie.title
                    )
                }
            } catch {
                favoriteMappedMovieModels = []
            }
            completion(favoriteMappedMovieModels)
        }
    
    func deleteMovie(by id: Int) throws {
        try serviceLocator.favoriteMoviesService.removeMovieFromFavorites(by: id)
    }
    
}
