//
//  NewsListRequest.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import Foundation

struct NewsListRequest: RequestType {
    typealias Response = NewsList
    typealias ErrorType = NewsListError
    
    var path: String = URLRepository.topStoriesPath
    var queryItems: [URLQueryItem]?
    var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
}
