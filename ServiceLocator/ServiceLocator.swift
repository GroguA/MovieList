//
//  ServiceLocator.swift
//  MovieList
//
//  Created by Александра Сергеева on 15.06.2024.
//

import Foundation

class ServiceLocator {
    static let shared = ServiceLocator()
    
    lazy var networkService: IMovieNetworkService = MovieNetworkService()
    lazy var favoriteMoviesService: IFavoriteMoviesService = FavoriteMoviesService()
    lazy var imageDownloader = ImageDownloader()
        
    private init() { }
    
}
