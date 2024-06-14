//
//  MovieListPresenter.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import Foundation

protocol MovieListPresenterProtocol {
    func didLoad(ui: MovieListControllerProtocol)
    func movieDidChoose(at index: Int)
}

class MovieListPresenterImp {
    private weak var ui: MovieListControllerProtocol?
    
    private var movies = [MovieModel]()
    
    private let interactor: MovieListInteractorProtocol
    
    init(interactor: MovieListInteractorProtocol) {
        self.interactor = interactor
    }
}

extension MovieListPresenterImp: MovieListPresenterProtocol {
    func didLoad(ui: MovieListControllerProtocol) {
        self.ui = ui
        interactor.fetchMovies { movies in
            self.movies = movies
            ui.showMovies(movies)
        }
    }
    
    func movieDidChoose(at index: Int) {
        
    }
}
