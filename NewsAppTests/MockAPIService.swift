//
//  MockAPIService.swift
//  NewsAppTests
//
//  Created by Giorgi Shukakidze on 21.08.21.
//

@testable import NewsApp
import Foundation
import Combine

final class MockAPIService: APIService {
    var stubs: [Any] = []
    
    func stub<Request: RequestType>(for: Request.Type, mockResponse: @escaping (() -> AnyPublisher<Request.Response, Request.ErrorType>)) {
        stubs.append(mockResponse)
    }
    
    func fetchResponse<Request: RequestType>(from request: Request) -> AnyPublisher<Request.Response, Request.ErrorType> {
        let stub = stubs.last as? (() -> AnyPublisher<Request.Response, Request.ErrorType>)
        let mockResponse = stub?()
        
        return mockResponse ?? Empty<Request.Response, Request.ErrorType>().eraseToAnyPublisher()
    }
}
