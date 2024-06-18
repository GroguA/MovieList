//
//  MovieNetworkService.swift
//  MovieList
//
//  Created by Александра Сергеева on 14.06.2024.
//

import Foundation

protocol IMovieNetworkService {
    func getPopularMovies(page: Int, completion: @escaping (Result<[MovieScheme], Error>) -> Void)
    func searchMovieByQuery(_ query: String, completion: @escaping (Result<[MovieScheme], Error>) -> Void)
}

final class MovieNetworkService {
    private let apiKey = "575b12481e57259feb84daf392f42b85"
    private let session = URLSession.shared
    private let mapper = JsonDecoderWrapper()
    
    private func makeURLRequest(endpoint: String, queryItems: [URLQueryItem]) -> URLRequest? {
        var urlComponents = URLComponents(string: endpoint)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    private func makePopularMoviesRequest(page: Int) -> URLRequest? {
        let endpoint = "https://api.themoviedb.org/3/movie/popular"
        let apiKeyItem = URLQueryItem(name: "api_key", value: apiKey)
        let languageItem = URLQueryItem(name: "language", value: "en-US")
        let pageItem = URLQueryItem(name: "page", value: "\(page)")
        
        let queryItems = [apiKeyItem, languageItem, pageItem]
        return makeURLRequest(endpoint: endpoint, queryItems: queryItems)
    }
    
    private func makeMovieRequestByQuery(_ query: String) -> URLRequest? {
        let endpoint = "https://api.themoviedb.org/3/search/movie"
        let apiKeyItem = URLQueryItem(name: "api_key", value: apiKey)
        let languageItem = URLQueryItem(name: "language", value: "en-US")
        let queryItem = URLQueryItem(name: "query", value: query)
        
        let queryItems = [apiKeyItem, languageItem, queryItem]
        return makeURLRequest(endpoint: endpoint, queryItems: queryItems)
    }
    
}

extension MovieNetworkService: IMovieNetworkService {
    func fetchMovies(with request: URLRequest, completion: @escaping (Result<[MovieScheme], Error>) -> Void) {
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            if let error = error {
                completion(.failure(NetworkErrors.parseError(message: error.localizedDescription)))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkErrors.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                self.mapper.parse(MoviesResponseScheme.self, from: data) { result in
                    switch result {
                    case .success(let model):
                        completion(.success(model.results))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            default:
                completion(.failure(NetworkErrors.statusCodeError(message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))))
            }
        }
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    func getPopularMovies(page: Int, completion: @escaping (Result<[MovieScheme], Error>) -> Void) {
        guard let request = makePopularMoviesRequest(page: page) else {
            completion(.failure(NetworkErrors.invalidRequest))
            return
        }
        fetchMovies(with: request, completion: completion)
    }
    
    func searchMovieByQuery(_ query: String, completion: @escaping (Result<[MovieScheme], Error>) -> Void) {
        guard let request = makeMovieRequestByQuery(query) else {
            completion(.failure(NetworkErrors.invalidRequest))
            return
        }
        fetchMovies(with: request, completion: completion)
    }
    
}
