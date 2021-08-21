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
}
