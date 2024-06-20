//
//  FavoriteMoviesPresenter.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import Foundation

protocol IFavoriteMoviesPresenter {
    var onMovieDeleted: ((FavoriteMovieModel) -> Void)? {get set}
    func didLoad(ui: IFavoriteMoviesViewController)
    func movieDeleted(at index: Int)
    func onMovieTapped(at index: Int)
}

final class FavoriteMoviesPresenter {
    var onMovieDeleted: ((FavoriteMovieModel) -> Void)?
    private weak var ui: IFavoriteMoviesViewController?
    private var movies = [FavoriteMovieModel]()
    private let interactor: IFavoriteMoviesInteractor
    private let router: IFavoriteMoviesRouter
    
    init(interactor: IFavoriteMoviesInteractor, router: IFavoriteMoviesRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension FavoriteMoviesPresenter: IFavoriteMoviesPresenter {
    func didLoad(ui: IFavoriteMoviesViewController) {
        self.ui = ui
        interactor.loadFavoriteMovies { movies in
            self.movies = movies
            if !movies.isEmpty {
                self.ui?.showMovies(movies)
            } else {
                self.ui?.showFavoriteMoviesAreEmpty()
            }
        }
    }
    
    func movieDeleted(at index: Int) {
        let deletedMovie = movies[index]
        movies.remove(at: index)
        do {
            try interactor.deleteMovie(by: deletedMovie.id)
            ui?.showMovies(movies)
            onMovieDeleted?(deletedMovie)
            if movies.isEmpty {
                ui?.showFavoriteMoviesAreEmpty()
            }
        } catch CoreDataErrors.runtimeError(let message) {
            ui?.showError(with: message)
        } catch {
            ui?.showError(with: "An unexpected error occurred: \(error.localizedDescription)")
        }
    }
    
    func onMovieTapped(at index: Int) {
        router.showMovieDetailsScreen(movieId: movies[index].id)
    }
    
}
