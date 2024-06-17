//
//  MovieScheme.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import Foundation

struct MoviesResponseScheme: Codable {
    let results: [MovieScheme]
}

struct MovieScheme: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case id, title
    }
}
