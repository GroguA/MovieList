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
    func dislikeMovie(at index: Int)
    func likeMovie(at index: Int)
}

final class MovieListPresenter {
    private weak var ui: IMovieListController?
    
    private var movies = [MovieModel]()
    
    private var interactor: IMovieListInteractor
    
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
    
    func dislikeMovie(at index: Int) {
        interactor.dislikeMovie(at: index)
        interactor.updateMovies { [weak self] movies in
            self?.movies = movies
            DispatchQueue.main.async {
                self?.ui?.showMovies(movies)
            }
        }
    }
    
    func likeMovie(at index: Int) {
        interactor.likeMovie(at: index)
        interactor.updateMovies { [weak self] movies in
            self?.movies = movies
            DispatchQueue.main.async {
                self?.ui?.showMovies(movies)
            }
        }
    }
}


