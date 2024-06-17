//
//  FavoriteMoviesTableViewCell.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import UIKit

class FavoriteMoviesCollectionViewCell: UITableViewCell {
    static let identifier = String(describing: FavoriteMoviesCollectionViewCell.self)
    
    private lazy var moviePoster: UIImageView = {
        let poster = UIImageView(frame: .zero)
        poster.layer.cornerRadius = 8
        poster.layer.masksToBounds = true
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.contentMode = .scaleToFill
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

private extension FavoriteMoviesCollectionViewCell {
    func setupViews() {
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitle)
        
        setConstraints()
    }
    
    func setConstraints() {
        let constraints = [
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            moviePoster.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            movieTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
        ]
    }
}
