//
//  Endpoints.swift
//  MovieList
//
//  Created by Александра Сергеева on 08.04.2025.
//

import Foundation

enum Endpoints {
    static let baseURL = "https://api.themoviedb.org/3"
    
    case searchMovie
    case getMovieDetails(Int)
    case getPopularMovies

    var path: String {
        switch self {
        case .searchMovie:
            return Self.baseURL + "/search/movie"
        case .getMovieDetails(let id):
            return Self.baseURL + "/movie/\(id)"
        case .getPopularMovies:
            return Self.baseURL + "/movie/popular"
        }
    }
}

