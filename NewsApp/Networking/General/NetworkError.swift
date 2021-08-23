//
//  NetworkError.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 23.08.21.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case internalError(Int, Data)
    case serverError
    case other(String)
}
