//
//  NetworkError.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

// MARK: - Services/NetworkError.swift
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case serverError(Int)
    case networkError(Error)
    case timeoutError
    case connectionFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .timeoutError:
            return "Request timed out"
        case .connectionFailed:
            return "Failed to connect to server. Make sure your API is running on localhost:8080"
        }
    }
}

