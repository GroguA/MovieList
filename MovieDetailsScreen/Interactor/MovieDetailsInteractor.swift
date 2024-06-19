//
//  MovieDetailsInteractor.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import Foundation

protocol IMovieDetailsInteractor {
    func fetchMovieDetails()
}

final class MovieDetailsInteractor {
    private let serviceLocator = ServiceLocator.shared
}

extension MovieDetailsInteractor: IMovieDetailsInteractor {
    func fetchMovieDetails() {
        
    }
}
