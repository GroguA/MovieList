//
//  FavoriteMoviesAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

enum FavoriteMoviesAssembly {
    static func createFavoriteMoviesModule(with navigationController: UINavigationController) -> FavoriteMoviesViewController {
        let interactor = FavoriteMoviesInteractor()
        let router = FavoriteMoviesRouter(navigationController: navigationController)
        let presenter = FavoriteMoviesPresenter(interactor: interactor, router: router)
        let view = FavoriteMoviesViewController(presenter: presenter)
        return view
    }
}
