//
//  Article.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import Foundation

struct Article: Codable, Identifiable {
    let title: String
    let description: String?
    let publishedAt: Date
    let urlString: String
    let imageUrlString: String?
    let content: String?
    
    let id: String = UUID().uuidString
    
    var url: URL? { URL(string: urlString) }
    var imageURL: URL? { URL(string: imageUrlString ?? "") }
    
    var publishedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: publishedAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, description, publishedAt, content
        case urlString = "url"
        case imageUrlString = "urlToImage"
    }
}
