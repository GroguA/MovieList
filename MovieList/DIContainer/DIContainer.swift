//
//  DIContainer.swift
//  MovieList
//
//  Created by Александра Сергеева on 09.04.2025.
//

import UIKit
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    let container = Container()
    
    private init() {
        registerModules()
    }
    
    private func registerModules() {
        // FavoriteMovies
        container.register(FavoriteMoviesInteractor.self) { _ in
            FavoriteMoviesInteractor()
        }
        
        container.register(FavoriteMoviesRouter.self) { _, nav in
            FavoriteMoviesRouter(navigationController: nav)
        }

        container.register(FavoriteMoviesPresenter.self) { (r: Resolver, nav: UINavigationController) in
            let interactor = r.resolve(FavoriteMoviesInteractor.self)!
            let router = r.resolve(FavoriteMoviesRouter.self, argument: nav)!
            return FavoriteMoviesPresenter(interactor: interactor, router: router)
        }

        container.register(FavoriteMoviesViewController.self) { (r: Resolver, nav: UINavigationController) in
            let presenter = r.resolve(FavoriteMoviesPresenter.self, argument: nav)!
            let vc = FavoriteMoviesViewController(presenter: presenter)
            return vc
        }

        // MovieList
        container.register(MovieListInteractor.self) { _ in
            MovieListInteractor()
        }

        container.register(MovieListRouter.self) { _, nav in
            MovieListRouter(navigationController: nav)
        }

        container.register(MovieListPresenter.self) { (r: Resolver, nav: UINavigationController) in
            let interactor = r.resolve(MovieListInteractor.self)!
            let router = r.resolve(MovieListRouter.self, argument: nav)!
            return MovieListPresenter(interactor: interactor, router: router)
        }

        container.register(MovieListViewController.self) { (r: Resolver, nav: UINavigationController) in
            let presenter = r.resolve(MovieListPresenter.self, argument: nav)!
            let vc = MovieListViewController(presenter: presenter)
            return vc
        }

        // MovieDetails
        container.register(MovieDetailsInteractor.self) { _, movieId in
            MovieDetailsInteractor(movieId: movieId)
        }

        container.register(MovieDetailsPresenter.self) { (r: Resolver, movieId: Int) in
            let interactor = r.resolve(MovieDetailsInteractor.self, argument: movieId)!
            return MovieDetailsPresenter(interactor: interactor)
        }

        container.register(MovieDetailsViewController.self) { (r: Resolver, movieId: Int) in
            let presenter = r.resolve(MovieDetailsPresenter.self, argument: movieId)!
            let vc = MovieDetailsViewController(presenter: presenter)
            return vc
        }
    }
}
