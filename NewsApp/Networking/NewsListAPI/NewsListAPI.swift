//
//  NewsListAPI.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import Foundation
import Combine

class NewsListAPI {
    private let serviceManager: APIService
    private var request = NewsListRequest()

    init(serviceManager: APIService = NetworkManager.shared) {
        self.serviceManager = serviceManager
    }
    
    var sorting: SortingOption = .popularity
    var language: Language = .english
    
    func fetchNewsList(for page: Int = 1,
                       pageSize: Int = Constants.pageSize
    ) -> AnyPublisher<NewsList, NewsListError> {
        request.queryItems = [
            URLQueryItem(name: "language", value: language.rawValue),
            URLQueryItem(name: "sortBy", value: sorting.rawValue),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize))
        ]
        
        return serviceManager.fetchResponse(from: request)
    }
}

//For future purposes to let user choose
extension NewsListAPI {
    enum SortingOption: String {
        case relevancy, popularity, publishedAt
    }
    
    enum Language: String {
        case arabic = "ar"
        case german = "de"
        case english = "en"
        case spanish = "es"
        case french = "fr"
        case hebrew = "he"
        case italian = "it"
        case dutch = "nl"
        case norwegian = "no"
        case portuguese = "pt"
        case russian = "ru"
        case northern = "se"
        case chinese = "zh"
    }
}
