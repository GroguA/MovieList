//
//  FavoriteMoviesContainerView.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

final class FavoriteMoviesContentView: UIView {
    lazy var favoriteMoviesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(FavoriteMoviesTableViewCell.self, forCellReuseIdentifier: FavoriteMoviesTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var tableViewDataSource: FavoriteMoviesTableViewDataSource?
    
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
        addSubview(favoriteMoviesTableView)
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            favoriteMoviesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            favoriteMoviesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            favoriteMoviesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            favoriteMoviesTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupDataSource() {
        tableViewDataSource = FavoriteMoviesTableViewDataSource(tableView: favoriteMoviesTableView)
        tableViewDataSource?.makeDataSource()
    }
    
}
