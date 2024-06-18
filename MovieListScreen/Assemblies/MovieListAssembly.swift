//
//  MovieListAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import UIKit

enum MovieListAssembly {
    static func createMovieListModule(with navigationController: UINavigationController) -> UIViewController {
        let interactor = MovieListInteractor()
        let router = MovieListRouter(navigationController: navigationController)
        let presenter = MovieListPresenter(interactor: interactor, router: router)
        let view = MovieListViewController(presenter: presenter)
        return view
    }
}
