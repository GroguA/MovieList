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

class MovieListCollectionViewDataSource {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MovieModel>

    private var dataSource: DataSource?
    
    private var collectionView: UICollectionView
    
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
                
                cell.fillCell(with: movie)
                return cell
            })
    }

    func applySnapshot(movies: [MovieModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

