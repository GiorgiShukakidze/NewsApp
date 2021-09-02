//
//  RequestType.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import Foundation

protocol RequestType {
    associatedtype Response: Codable
    associatedtype ErrorType: Error
    
    var baseURLString: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headerParameters: [String : String]? { get }
    var decoder: JSONDecoder { get }

    func request() -> URLRequest?
    func mapError(_ error: Error) -> ErrorType
}

//MARK: - Default implementation
extension RequestType {
    var baseURLString: String { URLRepository.baseURL }
    var headerParameters: [String : String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    
    var baseURL: URL? { URL(string: baseURLString)}
    var fullUrl: URL? { URL(string: path, relativeTo: baseURL)}

    func request() -> URLRequest? {
        guard let pathURL = fullUrl else { return nil }
        
        var components = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        if let components = components,
           let url = components.url {
            var urlRequest = URLRequest(url: url)
            
            urlRequest.timeoutInterval = TimeInterval(1000)
            for (key, value) in headerParameters ?? [:] {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
            
            return urlRequest
        }
        
        return nil
    }
    
    func mapError(_ error: Error) -> NewsListError {
        if let networkError = error as? NetworkError {
            return mapNetworkError(networkError)
        }
        
        if let decodeError = error as? DecodingError {
            return .parseError(decodeError.localizedDescription)
        }
        
        return NewsListError.other(error.localizedDescription)
    }
    
    private func mapNetworkError(_ error: NetworkError) -> NewsListError {
        switch error {
        case .internalError(let code, let data):
            switch code {
            case 400:
                let errorData = try? JSONDecoder().decode(NewsListError.ErrorData.self, from: data)
                return .badRequest(errorData)
            case 401: return .unauthorized
            case 429: return .maxRequests
            default: return .other(error.localizedDescription)
            }
        case .serverError: return .other(error.localizedDescription)
        case .invalidRequest: return .invalidURL
        case .other(let description): return .other(description)
        }
    }
}
