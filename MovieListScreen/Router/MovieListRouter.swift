//
//  MovieListRouter.swift
//  MovieList
//
//  Created by Александра Сергеева on 15.06.2024.
//

import UIKit

protocol CarsListRouterProtocol: AnyObject {
    static func showFavoriteMoviesScreen(navigationController: UINavigationController?)
}

final class MovieListRouter {
        static func showFavoriteMoviesScreen(navigationController: UINavigationController?) {
            let viewController = FavoriteMoviesAssembly.createFavoriteMoviesModule()
            navigationController?.pushViewController(viewController, animated: true)
        }
}
