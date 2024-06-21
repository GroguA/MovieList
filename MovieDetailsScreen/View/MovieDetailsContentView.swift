//
//  MovieDetailsContentView.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import UIKit

final class MovieDetailsContentView: UIView {
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
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.layer.cornerRadius = 8
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var errorLabel = LabelsFactory.createLabel(isCenterAlignment: true)
    
    private lazy var labelsStackView = StackViewsFactory.createStackView(with: [
        statusLabel,
        releaseDateLabel,
        popularityLabel,
        budgetLabel,
        originalLanguageLabel,
    ])
    
    private lazy var infoLabelsStackView = StackViewsFactory.createStackView(with: [
        statusInfoLabel,
        releaseDateInfoLabel,
        popularityInfoLabel,
        budgetInfoLabel,
        originalLanguageInfoLabel,
    ])
    
    private lazy var mainStackView = StackViewsFactory.createStackView(with: [
        labelsStackView,
        infoLabelsStackView
    ], isVertical: false)
    
    private lazy var isMovieFavoriteLabel = LabelsFactory.createLabel(isTextBold: true)
    private lazy var genreLabel = LabelsFactory.createLabel(with: "Genre:", isTextBold: true)
    private lazy var genreInfoLabel = LabelsFactory.createLabel()
    
    private lazy var statusLabel = LabelsFactory.createLabel(with: "Status:", isTextBold: true)
    private lazy var releaseDateLabel = LabelsFactory.createLabel(with: "Release date:", isTextBold: true)
    private lazy var popularityLabel = LabelsFactory.createLabel(with: "Popularity:", isTextBold: true)
    private lazy var budgetLabel = LabelsFactory.createLabel(with: "Budget:", isTextBold: true)
    private lazy var originalLanguageLabel = LabelsFactory.createLabel(with: "Original language:", isTextBold: true)
    
    private lazy var statusInfoLabel = LabelsFactory.createLabel()
    private lazy var releaseDateInfoLabel = LabelsFactory.createLabel()
    private lazy var popularityInfoLabel = LabelsFactory.createLabel()
    private lazy var budgetInfoLabel = LabelsFactory.createLabel()
    private lazy var originalLanguageInfoLabel = LabelsFactory.createLabel()
    
    private let serviceLocator = ServiceLocator.shared
    
    private let constraintOffset: CGFloat = 16
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillMovieInfo(with movie: MovieDetailsModel) {
        errorLabel.isHidden = true
        retryButton.isHidden = true
        setVisibilityOfViews()
        
        if let pathToImage = movie.pathToImage {
            serviceLocator.imageDownloader.fetchImage(pathToImage: pathToImage, imageView: movieImage)
        }
        statusInfoLabel.text = movie.status
        releaseDateInfoLabel.text = movie.releaseDate
        budgetInfoLabel.text = movie.budget
        genreInfoLabel.text = movie.genre
        isMovieFavoriteLabel.text = movie.isMovieFavorite
        originalLanguageInfoLabel.text = movie.originalLanguage
        popularityInfoLabel.text = movie.popularity
        
    }
    
    func showErrorText(_ text: String) {
        errorLabel.isHidden = false
        errorLabel.text = text
        setVisibilityOfViews(isHidden: true)
        retryButton.isHidden = false
    }
    
    func setupActivityViewAnimation(_ active: Bool = false) {
        if active {
            setVisibilityOfViews(isHidden: true)
            retryButton.isHidden = true
            errorLabel.isHidden = true
            activityIndicatorView.startAnimating()
        } else {
            setVisibilityOfViews()
            activityIndicatorView.stopAnimating()
        }
    }
}

private extension MovieDetailsContentView {
    func setupViews() {
        backgroundColor = .systemBackground
        
        addSubview(movieImage)
        addSubview(isMovieFavoriteLabel)
        addSubview(mainStackView)
        addSubview(genreLabel)
        addSubview(genreInfoLabel)
        addSubview(errorLabel)
        addSubview(retryButton)
        addSubview(activityIndicatorView)
        
        errorLabel.isHidden = true
        retryButton.isHidden = true
        activityIndicatorView.isHidden = true
        
        setConstraints()
    }
    
    func setConstraints() {
        let constraints = [
            movieImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: constraintOffset),
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintOffset),
            movieImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintOffset),
            
            mainStackView.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: constraintOffset),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintOffset),
            mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -constraintOffset),
            
            genreLabel.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: constraintOffset),
            genreLabel.leadingAnchor.constraint(equalTo: labelsStackView.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: labelsStackView.trailingAnchor),
            
            genreInfoLabel.topAnchor.constraint(equalTo: genreLabel.topAnchor),
            genreInfoLabel.leadingAnchor.constraint(equalTo: infoLabelsStackView.leadingAnchor),
            genreInfoLabel.trailingAnchor.constraint(equalTo: infoLabelsStackView.trailingAnchor),
            
            isMovieFavoriteLabel.topAnchor.constraint(greaterThanOrEqualTo: genreInfoLabel.bottomAnchor, constant: constraintOffset),
            isMovieFavoriteLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            isMovieFavoriteLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -constraintOffset),
            
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: constraintOffset),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -constraintOffset),
            
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 64),
            retryButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 60),
            
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func setVisibilityOfViews(isHidden: Bool = false) {
        mainStackView.isHidden = isHidden
        isMovieFavoriteLabel.isHidden = isHidden
        genreLabel.isHidden = isHidden
        genreInfoLabel.isHidden = isHidden
    }
    
}
