//
//  MovieListCollectionViewDataSource.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import UIKit

final class MovieListCollectionViewDataSource {
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MovieModel>
    
    var dataSource: DataSource?
    var presenter: IMovieListPresenter?
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
                
                cell.fillCell(with: movie,
                              onLikeButtonClicked: { self.likeMovie(movie)},
                              onDislikeButtonClicked: { self.dislikeMovie(movie)}
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
}

private extension MovieListCollectionViewDataSource {
    func likeMovie(_ movie: MovieModel) {
        guard let index = dataSource?.snapshot().indexOfItem(movie) else { return }
        presenter?.movieLiked(at: index)
    }
    
    func dislikeMovie(_ movie: MovieModel) {
        guard let index = dataSource?.snapshot().indexOfItem(movie) else { return }
        presenter?.movieDisliked(at: index)
    }
    
}
