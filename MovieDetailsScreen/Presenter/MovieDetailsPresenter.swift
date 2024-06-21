//
//  MovieDetailsPresenter.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import Foundation

protocol IMovieDetailsPresenter {
    func didLoad(ui: IMovieDetailsViewController, completion: @escaping (String) -> Void)
}

final class MovieDetailsPresenter {
    private weak var ui: IMovieDetailsViewController?
    private var interactor: IMovieDetailsInteractor
    
    
    init(interactor: IMovieDetailsInteractor) {
        self.interactor = interactor
    }
}

extension MovieDetailsPresenter: IMovieDetailsPresenter {
    func didLoad(ui: any IMovieDetailsViewController, completion: @escaping (String) -> Void) {
        self.ui = ui
        self.ui?.showLoadingProccess()
        interactor.fetchMovieDetails() { [weak self] result in
            self?.ui?.hideLoadingProccess()
            switch result {
            case .success(let movie):
                self?.ui?.showMovie(movie)
                completion(movie.navigationItemTitle)
            case .failure(let error):
                self?.ui?.showErorr(error.localizedDescription)
            }
        }
    }
}
