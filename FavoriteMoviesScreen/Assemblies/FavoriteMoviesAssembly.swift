//
//  FavoriteMoviesAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

enum FavoriteMoviesAssembly {
    static func createFavoriteMoviesModule(with navigationController: UINavigationController) -> FavoriteMoviesViewController {
        return DIContainer.shared.container.resolve(FavoriteMoviesViewController.self, argument: navigationController)!
    }
}
