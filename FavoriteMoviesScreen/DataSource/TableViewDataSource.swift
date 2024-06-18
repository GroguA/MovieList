//
//  TableViewDataSource.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

final class FavoriteMoviesTableViewDataSource {
    enum TableSection {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<TableSection, FavoriteMovieModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<TableSection, FavoriteMovieModel>
    
    var dataSource: DataSource?
    
    private var tableView: UITableView
    
    var presenter: IFavoriteMoviesPresenter?
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func makeDataSource() {
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, movie) -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: FavoriteMoviesTableViewCell.identifier,
                    for: indexPath
                ) as? FavoriteMoviesTableViewCell else { return nil }
                
                cell.fillCell(with: movie)
                return cell
            })
    }
    
    func applySnapshot(with movies: [FavoriteMovieModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
