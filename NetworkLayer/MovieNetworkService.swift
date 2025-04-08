//
//  MovieNetworkService.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import Foundation
import Alamofire

protocol IMovieNetworkService {
    func getPopularMovies(page: Int, completion: @escaping (Result<[MovieScheme], AFError>) -> Void)
    func searchMovieByQuery(_ query: String, completion: @escaping (Result<[MovieScheme], AFError>) -> Void)
    func getMovieDetailsById(_ id: Int, completion: @escaping (Result<MovieDetailsResponseScheme, AFError>) -> Void)
}

final class MovieNetworkService {
    private let apiKey = "575b12481e57259feb84daf392f42b85"
    
    private var commonParameters: Parameters {
        return [
            "api_key": apiKey,
            "language": "en-US"
        ]
    }
}


extension MovieNetworkService: IMovieNetworkService {
    func getPopularMovies(page: Int, completion: @escaping (Result<[MovieScheme], AFError>) -> Void) {
        var parameters = commonParameters
        parameters["page"] = page
        
        makeRequest(path: Endpoints.getPopularMovies.path, parameters: parameters) { (result: Result<MoviesResponseScheme, AFError>) in
            switch result {
            case .success(let model):
                completion(.success(model.results))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func searchMovieByQuery(_ query: String, completion: @escaping (Result<[MovieScheme], AFError>) -> Void) {
        var parameters = commonParameters
        parameters["query"] = query
        
        makeRequest(path: Endpoints.searchMovie.path, parameters: parameters)
        { (result: Result<MoviesResponseScheme, AFError>) in
                switch result {
                case .success(let model):
                    completion(.success(model.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getMovieDetailsById(_ id: Int, completion: @escaping (Result<MovieDetailsResponseScheme, AFError>) -> Void) {
        makeRequest(path: Endpoints.getMovieDetails(id).path, parameters: commonParameters) { (result: Result<MovieDetailsResponseScheme, AFError>) in
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

private extension MovieNetworkService {
    func makeRequest<T: Decodable>(
        path: String,
        parameters: Parameters,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(path, parameters: parameters)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
