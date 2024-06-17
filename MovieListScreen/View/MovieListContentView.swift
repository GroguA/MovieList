//
//  MovieListContentView.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import UIKit

class MovieListContentView: UIView {
    
    lazy var moviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    lazy var showFavoriteMoviesButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .light, scale: .default)
        let largeBoldHeart = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(largeBoldHeart, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .red
        button.addTarget(self, action: #selector(showFavoriteMoviesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Movie name"
        return searchController
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Error loading movies"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    var collectionViewDataSource: MovieListCollectionViewDataSource?
    
    init(delegate: UICollectionViewDelegate) {
        super.init(frame: .zero)
        moviesCollectionView.delegate = delegate
        setupView()
        setupDataSource()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MovieListContentView {
    func setupView() {
        backgroundColor = .white
        addSubview(moviesCollectionView)
        addSubview(errorLabel)
        addSubview(retryButton)
        addSubview(activityIndicatorView)
        errorLabel.isHidden = true
        retryButton.isHidden = true
        activityIndicatorView.isHidden = true
        
        let constraints = [
            moviesCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 64),
            retryButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 60),
            
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupDataSource() {
        collectionViewDataSource = MovieListCollectionViewDataSource(collectionView: moviesCollectionView)
        collectionViewDataSource?.makeDataSource()
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    @objc func showFavoriteMoviesButtonTapped() {
        
    }
}
