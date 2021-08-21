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
    @Published private(set) var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var state: NewsViewModelState = .idle
    
    var hasMorePages: Bool { articles.count < totalCount }
    
    private var cancellables: Set<AnyCancellable> = []
 
    private let service: NewsListAPI
    
    private let errorsSubject = PassthroughSubject<NewsListError, Never>()
    
    private var currentPage: Int = 1
    private var totalCount: Int = 0
    
    init(service: NewsListAPI = NewsListAPI()) {
        self.service = service
        
        bindOutputs()
    }
    
    //MARK: - User intents
    func fetchArticles() {
        state = .loading
        
        service.fetchNewsList(for: currentPage)
            .catch {[weak self] error -> AnyPublisher<NewsList, Never>  in
                self?.errorsSubject.send(error)
                self?.state = .error
                
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
    
    private func bindOutputs() {
        errorsSubject
            .map { _ in true }
            .assign(to: \.showError, on: self)
            .store(in: &cancellables)
        
        errorsSubject
            .map { error -> String in error.errorDescription ?? ""}
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
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
        errorMessage = ""
        showError = false
        currentPage = 1
        totalCount = 0
    }
}
