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
    
    private func makePopularMoviesRequest(page: Int) -> URLRequest? {
        var baseComponent = URLComponents(string: "https://api.themoviedb.org/3/movie/popular")
        let apiKey = URLQueryItem(name: "api_key", value: apiKey)
        let language = URLQueryItem(name: "language", value: "en-US")
        let page = URLQueryItem(name: "page", value: "\(page)")
        
        let parametrs = [apiKey, language, page]
        
        baseComponent?.queryItems = parametrs
        
        guard let baseUrlComponent = baseComponent?.url else {
            return nil
        }
        return URLRequest(url: baseUrlComponent)
    }
    
    private func makeMovieRequestByQuery(_ query: String) -> URLRequest? {
        var baseComponent = URLComponents(string: "https://api.themoviedb.org/3/search/movie")
        let apiKey = URLQueryItem(name: "api_key", value: apiKey)
        let language = URLQueryItem(name: "language", value: "en-US")
        let query = URLQueryItem(name: "query", value: query)
        
        let parametrs = [apiKey, language, query]
        
        baseComponent?.queryItems = parametrs
        
        guard let baseUrlComponent = baseComponent?.url else {
            return nil
        }
        return URLRequest(url: baseUrlComponent)
    }
}

extension MovieNetworkService: IMovieNetworkService {
    func getPopularMovies(page: Int, completion: @escaping (Result<[MovieScheme], Error>) -> Void) {
        guard let request = makePopularMoviesRequest(page: page) else {
            completion(.failure(NetworkErrors.invalidRequest))
            return
        }
        
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
    
    func searchMovieByQuery(_ query: String, completion: @escaping (Result<[MovieScheme], Error>) -> Void) {
        guard let request = makeMovieRequestByQuery(query) else {
            completion(.failure(NetworkErrors.invalidRequest))
            return
        }
        
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
}
