//
//  FavoriteMoviesRouter.swift
//  MovieList
//
//  Created by Александра Сергеева on 20.06.2024.
//

import UIKit

protocol IFavoriteMoviesRouter: AnyObject {
    func showMovieDetailsScreen(movieId: Int)
}

final class FavoriteMoviesRouter: IFavoriteMoviesRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showMovieDetailsScreen(movieId: Int) {
        let viewController = MovieDetailsAssembly.createMovieDetailsModule(movieId)
        navigationController.pushViewController(viewController, animated: true)
    }
}

