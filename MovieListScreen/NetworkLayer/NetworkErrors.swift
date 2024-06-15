//
//  NetworkErrors.swift
//  MovieList
//
//  Created by Александра Сергеева on 15.06.2024.
//

import Foundation

enum NetworkErrors: LocalizedError {
    case invalidRequest
    case invalidResponse
    case statusCodeError(message: String)
    case parseError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"
        case .statusCodeError(let description):
            return description
        case .parseError(let description):
            return description
        }
    }
}
