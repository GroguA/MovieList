//
//  MovieCollectionViewCell.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: MovieCollectionViewCell.self)
    
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
    
    private let imageDownloader = ImageDownloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillCell(with movie: MovieModel) {
        moviePoster.image = nil
        movieTitle.text = movie.title
        imageDownloader.fetchImage(pathToImage: movie.pathToImage, imageView: moviePoster)
    }
    
}

private extension MovieCollectionViewCell {
    func setupViews() {
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitle)
        
        let constraints = [
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            moviePoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            moviePoster.bottomAnchor.constraint(equalTo: movieTitle.topAnchor, constant: -4),
            
            movieTitle.leadingAnchor.constraint(equalTo: moviePoster.leadingAnchor, constant: 4),
            movieTitle.trailingAnchor.constraint(equalTo: moviePoster.trailingAnchor),
            movieTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
