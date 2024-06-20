//
//  MovieListRouter.swift
//  MovieList
//
//  Created by Александра Сергеева on 15.06.2024.
//

import UIKit

protocol IMovieListRouter: AnyObject {
    func showFavoriteMoviesScreen(onMovieDeleted: @escaping (FavoriteMovieModel) -> Void)
    func showMovieDetailsScreen(movieId: Int)
}

final class MovieListRouter: IMovieListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showFavoriteMoviesScreen(onMovieDeleted: @escaping (FavoriteMovieModel) -> Void) {
        let viewController = FavoriteMoviesAssembly.createFavoriteMoviesModule(with: navigationController)
        viewController.onMovieDeleted = onMovieDeleted
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMovieDetailsScreen(movieId: Int) {
        let viewController = MovieDetailsAssembly.createMovieDetailsModule(with: movieId)
        navigationController.pushViewController(viewController, animated: true)
    }
}
