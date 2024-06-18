//
//  FavoriteMoviesAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

enum FavoriteMoviesAssembly {
    static func createFavoriteMoviesModule() -> FavoriteMoviesViewController {
        let interactor = FavoriteMoviesInteractor()
        let presenter = FavoriteMoviesPresenter(interactor: interactor)
        let view = FavoriteMoviesViewController(presenter: presenter)
        
        return view
    }
}
