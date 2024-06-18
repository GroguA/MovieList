//
//  FavoriteMoviesTableViewCell.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

final class FavoriteMoviesTableViewCell: UITableViewCell {
    static let identifier = String(describing: FavoriteMoviesTableViewCell.self)
    
    private lazy var moviePoster: UIImageView = {
        let poster = UIImageView(frame: .zero)
        poster.layer.cornerRadius = 8
        poster.layer.masksToBounds = true
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.contentMode = .scaleAspectFit
        return poster
    }()
    
    private lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    private let serviceLocator = ServiceLocator.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillCell(with movie: FavoriteMovieModel) {
        moviePoster.image = nil
        movieTitle.text = nil
        
        movieTitle.text = movie.title
        serviceLocator.imageDownloader.fetchImage(pathToImage: movie.pathToImage, imageView: moviePoster)
    }
    
}

private extension FavoriteMoviesTableViewCell {
    func setupViews() {
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitle)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        let constraints = [
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            moviePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            moviePoster.widthAnchor.constraint(equalTo: moviePoster.heightAnchor, multiplier: 0.75),
            
            movieTitle.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 8),
            movieTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieTitle.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
