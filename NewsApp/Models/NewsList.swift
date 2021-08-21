//
//  NewsList.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import Foundation

struct NewsList: Codable {
    let status: Status
    let totalResults: Int
    let code: String?
    let message: String?
    let articles: [Article]
    
    enum Status: String, Codable {
        case ok, error
    }
}
