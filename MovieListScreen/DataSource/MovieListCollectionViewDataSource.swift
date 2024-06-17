//
//  MovieListCollectionViewDataSource.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import UIKit

enum Section {
    case main
}

final class MovieListCollectionViewDataSource {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MovieModel>
    
    var dataSource: DataSource?
    
    private var collectionView: UICollectionView
    
    var presenter: IMovieListPresenter?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func makeDataSource() {
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieCollectionViewCell.identifier,
                    for: indexPath
                ) as? MovieCollectionViewCell else { return nil }
                
                cell.fillCell(with: movie,
                              onLikeButtonClicked: { self.likeMovie(at: indexPath.item)},
                              onDislikeButtonClicked: { self.dislikeMovie(at: indexPath.item)}
                )
                return cell
            })
    }
    
    func applySnapshot(with movies: [MovieModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func reloadSnapshot(with movies: [MovieModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

private extension MovieListCollectionViewDataSource {
    func likeMovie(at index: Int) {
        self.presenter?.movieLiked(at: index)
    }
    
    func dislikeMovie(at index: Int) {
        self.presenter?.movieDisliked(at: index)
    }
}

