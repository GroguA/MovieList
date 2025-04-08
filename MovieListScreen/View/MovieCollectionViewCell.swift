//
//  MovieCollectionViewCell.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
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
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var dislikeImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.tintColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        moviePoster.image = nil
        
        likeImage.isHidden = false
        dislikeImage.isHidden = true
        likeImage.image = nil
        dislikeImage.image = nil
        
        likeImage.gestureRecognizers?.forEach { likeImage.removeGestureRecognizer($0) }
        dislikeImage.gestureRecognizers?.forEach { dislikeImage.removeGestureRecognizer($0) }
        
        movieTitle.text = nil
        
        dislikeAction = nil
        likeAction = nil
    }
    
    func fillCell(
        with movie: MovieModel,
        onLikeButtonClicked: @escaping () -> Void,
        onDislikeButtonClicked: @escaping () -> Void
    ){
        self.dislikeAction = onDislikeButtonClicked
        self.likeAction = onLikeButtonClicked
        
        if !movie.isMovieFavorite {
            likeImage.isHidden = false
            dislikeImage.isHidden = true
        } else {
            likeImage.isHidden = true
            dislikeImage.isHidden = false
        }
        
        addGestureRecognizers()
        
        movieTitle.text = movie.title
        likeImage.image = UIImage(systemName: movie.likeIconPath)
        dislikeImage.image = UIImage(systemName: movie.dislikeIconPath)
        
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
            moviePoster.bottomAnchor.constraint(lessThanOrEqualTo: movieTitle.topAnchor, constant: -4),
            
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
    
    func addGestureRecognizers() {
        let dislikeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likedImageTapped))
        dislikeImage.addGestureRecognizer(dislikeTapGestureRecognizer)
        
        let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dislikedImageTapped))
        likeImage.addGestureRecognizer(likeTapGestureRecognizer)
    }
    
    @objc func dislikedImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        likeAction?()
    }
    
    @objc func likedImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        dislikeAction?()
    }
}
