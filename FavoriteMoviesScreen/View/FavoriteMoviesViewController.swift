//
//  FavoriteMoviesViewController.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

protocol IFavoriteMoviesViewController: AnyObject {
    func showMovies(_ movies: [FavoriteMovieModel])
}

final class FavoriteMoviesViewController: UIViewController {
    var onMovieDeleted: ((FavoriteMovieModel) -> Void)?
    
    private lazy var contentView = FavoriteMoviesContentView(delegate: self)
    
    private var presenter: IFavoriteMoviesPresenter
        
    init(presenter: IFavoriteMoviesPresenter) {
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
        setupView()
        presenter.didLoad(ui: self)
        presenter.onMovieDeleted = { [weak self] deletedMovie in
            self?.onMovieDeleted?(deletedMovie)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.onMovieDeleted = nil
    }
    
}

extension FavoriteMoviesViewController: IFavoriteMoviesViewController {
    func showMovies(_ movies: [FavoriteMovieModel]) {
        self.contentView.tableViewDataSource?.applySnapshot(with: movies)
    }
    
}

extension FavoriteMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.presenter.movieDeleted(at: indexPath.row)
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

private extension FavoriteMoviesViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Favorite movies"
    }
}
