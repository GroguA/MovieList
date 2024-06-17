//
//  ImageDownloader.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import UIKit

final class ImageDownloader {
    
    private let session = URLSession.shared
    
    func fetchImage(pathToImage: String, imageView: UIImageView) {
        guard let imageUrl = URL(string: pathToImage) else { return }
        
        let request = URLRequest(url: imageUrl)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }
}
