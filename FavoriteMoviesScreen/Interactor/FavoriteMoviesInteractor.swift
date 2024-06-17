//
//  FavoriteMoviesInteractor.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import Foundation

protocol IFavoriteMoviesInteractor {
    func loadFavoriteMovies(completion: @escaping ([FavoriteMovieModel]) -> Void)
    
}

final class FavoriteMoviesInteractor {
    private let serviceLocator = ServiceLocator.shared
        
}

extension FavoriteMoviesInteractor: IFavoriteMoviesInteractor {
    func loadFavoriteMovies(
        completion: @escaping ([FavoriteMovieModel]) -> Void) {
            var favoriteMovies = [FavoriteMovieCoreDataModel]()
            var favoriteMappedMovieModels = [FavoriteMovieModel]()
            do {
                favoriteMovies = try self.serviceLocator.favoriteMoviesService.fetchFavoriteMovies()
            } catch {
                favoriteMappedMovieModels = []
            }
            favoriteMovies.forEach({ movie in
                let favoriteMovie = FavoriteMovieModel(
                    id: movie.id,
                    pathToImage: movie.pathToImage,
                    title: movie.title)
                favoriteMappedMovieModels.append(favoriteMovie)
            })
            completion(favoriteMappedMovieModels)
        }
}
