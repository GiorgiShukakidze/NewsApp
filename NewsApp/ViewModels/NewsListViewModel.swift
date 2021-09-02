//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import SwiftUI
import Combine

class NewsListViewModel: ObservableObject, NewsListViewModelType {
    @Published private(set) var articles: [Article] = []
    @Published var state: NewsViewModelState = .idle
    
    var hasMorePages: Bool { articles.count < totalCount }
    
    private var cancellables: Set<AnyCancellable> = []
 
    private let service: NewsListAPI
        
    private var currentPage: Int = 1
    private var totalCount: Int = 0
    
    init(service: NewsListAPI = NewsListAPI()) {
        self.service = service
    }
    
    //MARK: - User intents
    func fetchArticles() {
        state = .loading
        
        service.fetchNewsList(for: currentPage)
            .catch {[weak self] error -> AnyPublisher<NewsList, Never>  in
                self?.state = .error(error.errorDescription ?? "")
                
                return .init(Empty())
            }
            .sink {[weak self] newsList in
                self?.handleNewData(newsList)
            }
            .store(in: &cancellables)
    }
    
    func refresh() {
        reset()
        fetchArticles()
    }
    
    func fetchNextPage() {
        guard state != .loading && hasMorePages else { return }
        
        currentPage += 1
        fetchArticles()
    }
    
    private func handleNewData(_ newsList: NewsList) {
        if newsList.articles.isEmpty && currentPage == 1 {
            state = .empty
            articles = []
        } else {
            state = .complete
            totalCount = min(newsList.totalResults, Constants.numberOfMaxRequests)
            articles += newsList.articles
        }
    }
    
    private func reset() {
        articles = []
        state = .idle
        currentPage = 1
        totalCount = 0
    }
}
