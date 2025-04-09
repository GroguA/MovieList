//
//  MovieListAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import UIKit

enum MovieListAssembly {
    static func createMovieListModule(with navigationController: UINavigationController) -> UIViewController {
        return DIContainer.shared.container.resolve(MovieListViewController.self, argument: navigationController)!
    }
}
