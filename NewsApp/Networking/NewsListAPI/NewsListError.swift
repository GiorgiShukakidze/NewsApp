//
//  NewsListError.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 19.08.21.
//

import Foundation

enum NewsListError: Error, Equatable {
    case invalidURL
    case badRequest(ErrorData?)
    case unauthorized
    case maxRequests
    case other(String)
    case parseError(String)
    
    struct ErrorData: Codable, Equatable {
        let status: NewsList.Status
        let code: String
        let message: String
    }
}

extension NewsListError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest(let errorData): return NSLocalizedString("\(errorData?.message ?? "")", comment: "")
        default: return NSLocalizedString("Oops.. Something went wrong. Please try again.", comment: "")
            
/// In case explicit handling is needed for errors
//        case .invalidURL:
//            return NSLocalizedString("Invalid URL is provided", comment: "")
//        case .unauthorized:
//            return NSLocalizedString("Request is unauthorized", comment: "")
//        case .maxRequests:
//            return NSLocalizedString("Maximum number of requests reached", comment: "")
//        case .other(let description):
//            return NSLocalizedString("\(description)", comment: "")
//        case .parseError(let description):
//            return NSLocalizedString("Error parsing data \(description)", comment: "")
        }
    }
}

