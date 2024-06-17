//
//  FavoriteMoviesContainerView.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

class FavoriteMoviesContentView: UIView {

    lazy var favoriteMoviesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(FavoriteMoviesTableViewCell.self, forCellReuseIdentifier: FavoriteMoviesTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(delegate: UITableViewDelegate) {
        super.init(frame: .zero)
        favoriteMoviesTableView.delegate = delegate
        setupView()
        setupDataSource()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

private extension FavoriteMoviesContentView {
    func setupView() {
        
    }
    
    func setupDataSource() {
        
    }
}
