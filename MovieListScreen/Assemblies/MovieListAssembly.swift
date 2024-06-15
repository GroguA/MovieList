//
//  MovieListAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import UIKit

enum MovieListAssembly {
    static func createMovieListModule() -> UIViewController {
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter(interactor: interactor)
        let view = MovieListViewController(presenter: presenter)
        
        return view
    }
}
