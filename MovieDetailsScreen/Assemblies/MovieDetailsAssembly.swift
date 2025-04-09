//
//  MovieDetailsAssembly.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import Foundation

enum MovieDetailsAssembly {
    static func createMovieDetailsModule(_ movieId: Int) -> MovieDetailsViewController {
        return DIContainer.shared.container.resolve(MovieDetailsViewController.self, argument: movieId)!
    }
}
