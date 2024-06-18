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
    func movieDisliked(at index: Int)
    func movieLiked(at index: Int)
    func searchStartedBy(query: String)
    func searchStopped()
    func showFavoriteMoviesClicked()
    func movieDeletedFromFavorite(_ deletedMovie: FavoriteMovieModel)
}

final class MovieListPresenter {
    private weak var ui: IMovieListController?
    
    private var movies = [MovieModel]()
    
    private let interactor: IMovieListInteractor
    
    private let router: IMovieListRouter
    
    init(interactor: IMovieListInteractor, router: IMovieListRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension MovieListPresenter: IMovieListPresenter {
    func didLoad(ui: IMovieListController) {
        self.ui = ui
        self.ui?.showLoadingProccess()
        interactor.fetchMovies { result in
            self.ui?.hideLoadingProccess()
            switch result {
            case .success(let movies):
                self.movies = movies
                self.ui?.showMovies(movies)
            case .failure(let error):
                self.ui?.showError(error.localizedDescription)
            }
        }
    }
    
    func movieDidChoose(at index: Int) {
        
    }
    
    func movieDeletedFromFavorite(_ deletedMovie: FavoriteMovieModel) {
        interactor.movieDeletedFromFavorite(deletedMovie)
        interactor.updateMovies { movies in
            self.movies = movies
            self.ui?.showMovies(movies)
        }
    }
    
    func moviesScrolled() {
        interactor.loadMoreMovies { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                self.ui?.showMovies(movies)
            case .failure(let error):
                self.ui?.showError(error.localizedDescription)
            }
        }
    }
    
    func movieDisliked(at index: Int) {
        do {
            try interactor.dislikeMovie(at: index)
            interactor.updateMovies { movies in
                self.movies = movies
                self.ui?.showMovies(movies)
            }
        } catch CoreDataErrors.runtimeError(let message) {
            self.ui?.showStorageError(message)
        } catch {
            self.ui?.showError("An unexpected error occurred: \(error.localizedDescription)")
        }
    }
    
    func movieLiked(at index: Int) {
        do {
            try interactor.likeMovie(at: index)
            interactor.updateMovies { movies in
                self.movies = movies
                self.ui?.showMovies(movies)
            }
        } catch CoreDataErrors.runtimeError(let message) {
            self.ui?.showStorageError(message)
        } catch {
            self.ui?.showError("An unexpected error occurred: \(error.localizedDescription)")
        }
    }
    
    func searchStartedBy(query: String) {
        interactor.fetchMoviesByQuery(query) { result in
            switch result {
            case .success(let movies):
                if movies.isEmpty {
                    self.ui?.showError("Such movie not found")
                }
                self.movies = movies
                self.ui?.showMovies(movies)
            case .failure(let error):
                self.ui?.showError(error.localizedDescription)
            }
        }
    }
    
    func searchStopped() {
        interactor.searchStopped()
        interactor.updateMovies { movies in
            self.movies = movies
            self.ui?.showMovies(movies)
        }
    }
    
    func showFavoriteMoviesClicked() {
        router.showFavoriteMoviesScreen() { deletedMovie in
            self.movieDeletedFromFavorite(deletedMovie)
        }
    }
    
}


