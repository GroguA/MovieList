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
    
    private lazy var dataSource = contentView.collectionViewDataSource?.dataSource
    
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
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        
    }
    
}

extension MovieListViewController: IMovieListController {
    func showMovies(_ movies: [MovieModel]) {
        DispatchQueue.main.async {
            self.contentView.collectionViewDataSource?.applySnapshot(movies: movies)
        }
    }
    
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let movies = dataSource?.snapshot().itemIdentifiers else { return }
        if (indexPath.item == movies.count - 1) {
            presenter.moviesScrolled()
        }
    }
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        let optEncodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        guard let encodedText = optEncodedText else { return }
        presenter.searchStarted(query: encodedText)
    }
}

extension MovieListViewController:  UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchStopped()
    }
}
