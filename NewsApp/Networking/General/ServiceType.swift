//
//  ServiceType.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import Foundation
import Combine

protocol APIService {
    func fetchResponse<Request: RequestType>(from request: Request) -> AnyPublisher<Request.Response, Request.ErrorType>
}
