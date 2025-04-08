//
//  ImageDownloader.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import UIKit

import Kingfisher

final class ImageDownloader {
    func fetchImage(pathToImage: String, imageView: UIImageView) {
        guard let imageUrl = URL(string: pathToImage) else { return }
        
        DispatchQueue.main.async {
            imageView.kf.setImage(with: imageUrl)
        }
    }
}
