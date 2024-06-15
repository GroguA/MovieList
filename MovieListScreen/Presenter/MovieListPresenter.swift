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
    func moviesScrolled()
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
        interactor.fetchMovies { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                self.ui?.showMovies(movies)
            case .failure(_):
                break
            }
            
        }
    }
    
    func movieDidChoose(at index: Int) {
        
    }
    
    func moviesScrolled() {
        interactor.loadMoreMovies { result in
            switch result {
            case .success(let movies):
                self.movies += movies
                self.ui?.showMovies(movies)
            case .failure(_):
                break
            }
        }
    }
}

