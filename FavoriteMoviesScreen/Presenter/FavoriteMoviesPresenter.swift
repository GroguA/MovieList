//
//  FavoriteMoviesPresenter.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import Foundation

protocol IFavoriteMoviesPresenter {
    func didLoad(ui: IFavoriteMoviesViewController)
}

final class FavoriteMoviesPresenter {
    private weak var ui: IFavoriteMoviesViewController?
    
    private var movies = [FavoriteMovieModel]()
    
    private var interactor: IFavoriteMoviesInteractor
    
    init(interactor: IFavoriteMoviesInteractor) {
        self.interactor = interactor
    }
}

extension FavoriteMoviesPresenter: IFavoriteMoviesPresenter {
    func didLoad(ui: IFavoriteMoviesViewController) {
        self.ui = ui
        interactor.loadFavoriteMovies { movies in
            self.movies = movies
            ui.showMovies(movies)
        }
    }
}
