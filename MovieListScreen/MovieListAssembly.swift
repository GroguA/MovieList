//
//  MovieListAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import UIKit

enum MovieListAssembly {
    static func createCarsListModule() -> UIViewController {
        let interactor = MovieListInteractorImp()
        let presenter = MovieListPresenterImp(interactor: interactor)
        let view = MovieListViewController(presenter: presenter)
        
        return view
    }
}
