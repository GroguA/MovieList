//
//  Interactor.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import Foundation

protocol IMovieListInteractor {
    func fetchMovies(completion: @escaping ([MovieModel]) -> Void)
}

final class MovieListInteractor: IMovieListInteractor {
    func fetchMovies(completion: @escaping ([MovieModel]) -> Void) {
        let movieModel = MovieModel(title: "hello")
        completion([movieModel])
    }
}
