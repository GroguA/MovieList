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
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var noFavoriteMoviesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.text = "No favorite movies yet"
        return label
    }()
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert 
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
        addSubview(noFavoriteMoviesLabel)
        
        noFavoriteMoviesLabel.isHidden = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            favoriteMoviesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            favoriteMoviesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            favoriteMoviesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            favoriteMoviesTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            noFavoriteMoviesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noFavoriteMoviesLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupDataSource() {
        tableViewDataSource = FavoriteMoviesTableViewDataSource(tableView: favoriteMoviesTableView)
        tableViewDataSource?.makeDataSource()
    }
    
}
