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
    func showStorageError(_ error: String)
}

class MovieListViewController: UIViewController {
    
    private lazy var contentView = MovieListContentView(delegate: self)
    
    private lazy var searchController = contentView.searchController
    
    private var previousIndexPath: IndexPath? = nil
    
    private let presenter: IMovieListPresenter
    
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
        presenter.showFavoriteMoviesClicked()
    }
    
}

extension MovieListViewController: IMovieListController {
    func showMovies(_ movies: [MovieModel]) {
        callResultOnMain { [weak self] in
            self?.contentView.moviesCollectionView.isHidden = false
            self?.contentView.errorLabel.isHidden = true
            self?.contentView.retryButton.isHidden = true
            self?.contentView.collectionViewDataSource?.applySnapshot(with: movies)
        }
    }
    
    func showError(_ error: String?) {
        callResultOnMain { [weak self] in
            self?.contentView.moviesCollectionView.isHidden = true
            self?.contentView.errorLabel.isHidden = false
            self?.contentView.retryButton.isHidden = false
            self?.contentView.activityIndicatorView.isHidden = true
            self?.contentView.activityIndicatorView.stopAnimating()
            if let error {
                self?.contentView.errorLabel.text = error
            }
        }
    }
    
    func showLoadingProccess() {
        callResultOnMain { [weak self] in
            self?.contentView.activityIndicatorView.isHidden = false
            self?.contentView.activityIndicatorView.startAnimating()
            self?.contentView.moviesCollectionView.isHidden = true
            self?.contentView.errorLabel.isHidden = true
            self?.contentView.retryButton.isHidden = true
            self?.searchController.searchBar.text = nil
        }
    }
    
    func hideLoadingProccess() {
        callResultOnMain { [weak self] in
            self?.contentView.activityIndicatorView.isHidden = true
            self?.contentView.activityIndicatorView.stopAnimating()
            self?.contentView.moviesCollectionView.isHidden = false
            self?.contentView.errorLabel.isHidden = true
            self?.contentView.retryButton.isHidden = true
        }
    }
    
    func showStorageError(_ error: String) {
        contentView.errorAlert.message = error
        self.present(contentView.errorAlert, animated: true)
    }
    
    func callResultOnMain(result: @escaping () -> Void) {
        DispatchQueue.main.async {
            result()
        }
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.movieDidChoose(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let movies = contentView.collectionViewDataSource?.dataSource?.snapshot().itemIdentifiers else { return }
        if indexPath.item == (movies.count - 1) {
            presenter.moviesScrolled()
        }
    }
}

extension MovieListViewController:  UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchStopped()
        if let previousIndexPath = previousIndexPath {
                if let itemCount = self.contentView.collectionViewDataSource?.dataSource?.snapshot().numberOfItems, previousIndexPath.row < itemCount {
                    self.contentView.moviesCollectionView.scrollToItem(at: previousIndexPath, at: .top, animated: true)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces)
        else {
            return
        }
        let optEncodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        guard let encodedText = optEncodedText else { return }
        
        let visibleIndexPaths = contentView.moviesCollectionView.indexPathsForVisibleItems.sorted()
        
        if !visibleIndexPaths.isEmpty {
            previousIndexPath = visibleIndexPaths.first
        }
        
        presenter.searchStartedBy(query: encodedText)
        
        if let movies = contentView.collectionViewDataSource?.dataSource?.snapshot().itemIdentifiers, !movies.isEmpty {
            let indexPath = IndexPath(row: 0, section: 0)
            self.contentView.moviesCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
}
