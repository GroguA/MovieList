//
//  MovieListViewController.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import UIKit

protocol IMovieListController: AnyObject {
    func showMovies(_ movies: [MovieModel])
    func showError(_ error: String?)
    func showLoadingProccess()
    func hideLoadingProccess()
    func updateMovies(_ movies: [MovieModel])
}

class MovieListViewController: UIViewController {
    
    private lazy var contentView = MovieListContentView(delegate: self)
    
    private let presenter: IMovieListPresenter
    
    private lazy var searchController = contentView.searchController
    
    init(presenter: IMovieListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        contentView.collectionViewDataSource?.presenter = presenter
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
        setupViews()
    }
    
}

private extension MovieListViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Popular movies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.showFavoriteMoviesButton)
        
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        
        contentView.retryButton.addTarget(self, action: #selector(retryLoadingMovies), for: .touchUpInside)
        contentView.showFavoriteMoviesButton.addTarget(self, action: #selector(showFavoriteMoviesButtonTapped), for: .touchUpInside)

    }
    
    @objc func retryLoadingMovies() {
        presenter.didLoad(ui: self)
    }
    
    @objc func showFavoriteMoviesButtonTapped() {
        MovieListRouter.showFavoriteMoviesScreen(navigationController: navigationController)
    }
    
}

extension MovieListViewController: IMovieListController {
    func showMovies(_ movies: [MovieModel]) {
        DispatchQueue.main.async {
            self.contentView.moviesCollectionView.isHidden = false
            self.contentView.errorLabel.isHidden = true
            self.contentView.retryButton.isHidden = true
            self.contentView.collectionViewDataSource?.applySnapshot(with: movies)
        }
    }
    
    func updateMovies(_ movies: [MovieModel]) {
        DispatchQueue.main.async {
            self.contentView.collectionViewDataSource?.reloadSnapshot(with: movies)
        }
    }
    
    func showError(_ error: String?) {
        DispatchQueue.main.async {
            self.contentView.moviesCollectionView.isHidden = true
            self.contentView.errorLabel.isHidden = false
            self.contentView.retryButton.isHidden = false
            self.contentView.activityIndicatorView.isHidden = true
            self.contentView.activityIndicatorView.stopAnimating()
            if let error {
                self.contentView.errorLabel.text = error
            }
        }
    }
    
    func showLoadingProccess() {
        DispatchQueue.main.async {
            self.contentView.activityIndicatorView.isHidden = false
            self.contentView.activityIndicatorView.startAnimating()
            self.contentView.moviesCollectionView.isHidden = true
            self.contentView.errorLabel.isHidden = true
            self.contentView.retryButton.isHidden = true
        }
    }
    
    func hideLoadingProccess() {
        DispatchQueue.main.async {
            self.contentView.activityIndicatorView.isHidden = true
            self.contentView.activityIndicatorView.stopAnimating()
            self.contentView.moviesCollectionView.isHidden = false
            self.contentView.errorLabel.isHidden = true
            self.contentView.retryButton.isHidden = true
        }
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let movies = contentView.collectionViewDataSource?.dataSource?.snapshot().itemIdentifiers else { return }
        if (indexPath.item == movies.count - 1) {
            presenter.moviesScrolled()
        }
    }
}

extension MovieListViewController:  UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchStopped()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces)
        else {
            return
        }
        let optEncodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        guard let encodedText = optEncodedText else { return }
        presenter.searchStartedBy(query: encodedText)
        let indexPath = IndexPath(row: 0, section: 0)
        contentView.moviesCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
}
