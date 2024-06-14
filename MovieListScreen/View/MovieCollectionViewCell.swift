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
        title.textColor = .black
        title.numberOfLines = 0
        return title
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillCell(with movie: MovieModel) {
        
    }
    
}

private extension MovieCollectionViewCell {
    func setupViews() {
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitle)

    }
}
