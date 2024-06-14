//
//  MovieListPresenter.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import Foundation

protocol IMovieListPresenter {
    func didLoad(ui: IMovieListController)
    func movieDidChoose(at index: Int)
}

final class MovieListPresenter {
    private weak var ui: IMovieListController?
    
    private var movies = [MovieModel]()
    
    private let interactor: IMovieListInteractor
    
    init(interactor: IMovieListInteractor) {
        self.interactor = interactor
    }
}

extension MovieListPresenter: IMovieListPresenter {
    func didLoad(ui: IMovieListController) {
        self.ui = ui
        interactor.fetchMovies { movies in
            self.movies = movies
            ui.showMovies(movies)
        }
    }
    
    func movieDidChoose(at index: Int) {
        
    }
}
