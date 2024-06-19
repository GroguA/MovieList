//
//  MovieDetailsResponceScheme.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import Foundation

struct MovieDetailsResponseScheme: Codable {
    let id: Int
    let backdropPath: String?
    let budget: Int
    let originalLanguage: String
    let releaseDate: String
    let status: String
    let popularity: Double
    let title: String
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case budget, status, popularity, title, genres, id
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
