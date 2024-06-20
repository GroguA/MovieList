//
//  MovieDetailsAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import Foundation

enum MovieDetailsAssembly {
    static func createMovieDetailsModule(with movieId: Int) -> MovieDetailsViewController {
        let interactor = MovieDetailsInteractor(movieId: movieId)
        let presenter = MovieDetailsPresenter(interactor: interactor)
        let view = MovieDetailsViewController(presenter: presenter)
        return view
    }
}
