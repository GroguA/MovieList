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
    var isMovieFavorite: Bool
    let likeIconPath: String
    let dislikeIconPath: String
}
