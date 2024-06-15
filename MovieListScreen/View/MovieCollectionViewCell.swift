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
    
    private lazy var likeImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.tintColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dislikedImageTapped))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(likeTapGestureRecognizer)
        return image
    }()
    
    private lazy var dislikeImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.tintColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        let dislikeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likedImageTapped))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(dislikeTapGestureRecognizer)
        return image
    }()
    
    private var dislikeAction: (() -> Void)? = nil
    private var likeAction: (() -> Void)? = nil
    
    private let serviceLocator = ServiceLocator.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillCell(
        with movie: MovieModel,
        onLikeButtonClicked: @escaping () -> Void,
        onDislikeButtonClicked: @escaping () -> Void
    ){
        self.dislikeAction = onDislikeButtonClicked
        self.likeAction = onLikeButtonClicked
        
        likeImage.image = UIImage(systemName: movie.likeIconPath)
        dislikeImage.image = UIImage(systemName: movie.dislikeIconPath)
        
        if !movie.isMovieFavorite {
            likeImage.isHidden = false
            dislikeImage.isHidden = true
        } else {
            likeImage.isHidden = true
            dislikeImage.isHidden = false
        }
        
        moviePoster.image = nil
        movieTitle.text = movie.title
        
        serviceLocator.imageDownloader.fetchImage(pathToImage: movie.pathToImage, imageView: moviePoster)
    }
    
}

private extension MovieCollectionViewCell {
    func setupViews() {
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitle)
        self.insertSubview(likeImage, aboveSubview: moviePoster)
        self.insertSubview(dislikeImage, aboveSubview: moviePoster)
        
        let constraints = [
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            moviePoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            moviePoster.bottomAnchor.constraint(equalTo: movieTitle.topAnchor, constant: -4),
            
            movieTitle.leadingAnchor.constraint(equalTo: moviePoster.leadingAnchor, constant: 4),
            movieTitle.trailingAnchor.constraint(equalTo: moviePoster.trailingAnchor),
            movieTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            likeImage.topAnchor.constraint(equalTo: moviePoster.topAnchor, constant: 4),
            likeImage.widthAnchor.constraint(equalToConstant: 45),
            likeImage.heightAnchor.constraint(equalToConstant: 45),
            likeImage.trailingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: -4),
            
            dislikeImage.topAnchor.constraint(equalTo: moviePoster.topAnchor, constant: 4),
            dislikeImage.widthAnchor.constraint(equalToConstant: 45),
            dislikeImage.heightAnchor.constraint(equalToConstant: 45),
            dislikeImage.trailingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: -4),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func dislikedImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        likeAction?()
    }
    
    @objc func likedImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        dislikeAction?()
    }
}
