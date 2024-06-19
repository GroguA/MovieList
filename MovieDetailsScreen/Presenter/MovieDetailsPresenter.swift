//
//  MovieDetailsPresenter.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import Foundation

protocol IMovieDetailsPresenter {
    func didLoad(ui: IMovieDetailsViewController)
}

final class MovieDetailsPresenter {
    private weak var ui: IMovieDetailsViewController?
    private var movie: MovieDetailsModel? = nil
    private var interactor: IMovieDetailsInteractor
    
    init(interactor: IMovieDetailsInteractor) {
        self.interactor = interactor
    }
}

extension MovieDetailsPresenter: IMovieDetailsPresenter {
    func didLoad(ui: any IMovieDetailsViewController) {
        
    }
}
