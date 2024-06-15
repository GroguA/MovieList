//
//  MovieListViewController.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import UIKit

protocol IMovieListController: AnyObject {
    func showMovies(_ movies: [MovieModel])
}

class MovieListViewController: UIViewController {
    
    private lazy var contentView = MovieListContentView(delegate: self)
            
    private let presenter: IMovieListPresenter
    
    init(presenter: IMovieListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad(ui: self)
        setupView()
    }


}

private extension MovieListViewController {
    func setupView() {
        view.backgroundColor = .white
    }

}

extension MovieListViewController: IMovieListController {
    func showMovies(_ movies: [MovieModel]) {
        contentView.collectionViewDataSource?.applySnapshot(movies: movies)
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    
}