//
//  MovieDetailsContentView.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import UIKit

final class MovieDetailsContentView: UIView {
    lazy var movieImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.layer.cornerRadius = 8
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var errorLabel = LabelsFactory.createLabel()
    
    lazy var labelsStackView = StackViewsFactory.createStackView(with: [
        statusLabel,
        releaseDateLabel,
        popularityLabel,
        budgetLabel,
        originalLanguageLabel,
        genreLabel,
        isMovieFavoriteLabel
    ])
    
    lazy var infoLabelsStackView = StackViewsFactory.createStackView(with: [
        statusInfoLabel,
        releaseDateInfoLabel,
        popularityInfoLabel,
        budgetInfoLabel,
        originalLanguageInfoLabel,
        genreInfoLabel
    ])
    
    private lazy var releaseDateLabel = LabelsFactory.createLabel(with: "Release date: ", isTextBold: true)
    private lazy var popularityLabel = LabelsFactory.createLabel(with: "Popularity: ", isTextBold: true)
    private lazy var budgetLabel = LabelsFactory.createLabel(with: "Budget: ", isTextBold: true)
    private lazy var originalLanguageLabel = LabelsFactory.createLabel(with: "Original language", isTextBold: true)
    private lazy var statusLabel = LabelsFactory.createLabel(with: "Status: ", isTextBold: true)
    private lazy var genreLabel = LabelsFactory.createLabel(with: "Genre: ", isTextBold: true)
    private lazy var isMovieFavoriteLabel = LabelsFactory.createLabel(isTextBold: true)
    
    private lazy var releaseDateInfoLabel = LabelsFactory.createLabel()
    private lazy var popularityInfoLabel = LabelsFactory.createLabel()
    private lazy var budgetInfoLabel = LabelsFactory.createLabel()
    private lazy var originalLanguageInfoLabel = LabelsFactory.createLabel()
    private lazy var statusInfoLabel = LabelsFactory.createLabel()
    private lazy var genreInfoLabel = LabelsFactory.createLabel()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieDetailsContentView {
    func setupViews() {
        addSubview(movieImage)
        addSubview(labelsStackView)
        addSubview(infoLabelsStackView)
        
        setConstraints()
    }
    
    func setConstraints() {
        let constraints = [
            movieImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            movieImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            labelsStackView.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 16),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelsStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16),
            
            infoLabelsStackView.leadingAnchor.constraint(equalTo: labelsStackView.trailingAnchor, constant: 16),
            infoLabelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoLabelsStackView.bottomAnchor.constraint(equalTo: labelsStackView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
