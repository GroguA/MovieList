//
//  FavoriteMovieModel.swift
//  MovieList
//
//  Created by Александра Сергеева on 17.06.2024.
//

import Foundation

struct FavoriteMovieModel: Hashable, Identifiable {
    let id: Int
    let pathToImage: String
    let title: String
}
