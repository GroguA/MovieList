//
//  MovieModel.swift
//  MovieList
//
//  Created by Александра Сергеева on 13.06.2024.
//

import Foundation

struct MovieModel: Hashable {
    let id: Int
    let title: String
    let pathToImage: String
    let isMovieFavorite: Bool
    let likeIconPath: String
    let dislikeIconPath: String
    
    func copyWith(isMovieFavorite: Bool) -> MovieModel {
        return MovieModel(
            id: self.id,
            title: self.title,
            pathToImage: self.pathToImage,
            isMovieFavorite: isMovieFavorite,
            likeIconPath: self.likeIconPath,
            dislikeIconPath: self.dislikeIconPath
        )
    }
}
