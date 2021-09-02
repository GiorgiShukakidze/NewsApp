//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import Foundation
import Combine

class NetworkManager: APIService {
    static let shared = NetworkManager()
    
    private let baseURL: URL? = URL(string: URLRepository.baseURL)
    private let defaultHeaderItems = ["Authorization": "\(APIKeys.NewsAPIKey)"]
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchResponse<Request: RequestType>(from request: Request) -> AnyPublisher<Request.Response, Request.ErrorType> {
        guard var urlRequest = request.request() else {
            return Fail(error: request.mapError(NetworkError.invalidRequest)).eraseToAnyPublisher()
        }
        
        for (key, value) in defaultHeaderItems {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: RunLoop.main)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200 == httpResponse.statusCode else {
                    let responseCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    
                    switch responseCode {
                    case -1:
                        throw NetworkError.other("Invalid response")
                    case 400...499:
                        throw NetworkError.internalError(responseCode, data)
                    default:
                        throw NetworkError.serverError
                    }
                }
                
                return try request.decoder.decode(Request.Response.self, from: data)
            }
            .mapError { request.mapError($0) }
            .eraseToAnyPublisher()
    }
}
