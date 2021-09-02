//
//  NewsListViewModelTests.swift
//  NewsAppTests
//
//  Created by Giorgi Shukakidze on 21.08.21.
//

@testable import NewsApp
import XCTest
import Combine

class NewsListViewModelTests: XCTestCase {
    private var service: MockAPIService!
    private var newsListAPI: NewsListAPI!
    private var viewModel: NewsListViewModel!
    
    override func setUp() {
        service = MockAPIService()
        newsListAPI = NewsListAPI(serviceManager: service)
        viewModel = NewsListViewModel(service: newsListAPI)
    }
    
    override func tearDown() {
        service = nil
        newsListAPI = nil
        viewModel = nil
    }
    
    func testfetchNewsItems() {
        //Given
        stubForSuccessfulItem(.mockArticle1)
        
        //When
        viewModel.fetchArticles()
        
        //Then
        XCTAssertTrue(viewModel.articles.count == 1)
        XCTAssertEqual(viewModel.state, .complete)
    }
    
    func testfetchNextPage() {
        //Given
        stubForSuccessfulItem(.mockArticle1)
        viewModel.fetchArticles()
        XCTAssertTrue(viewModel.hasMorePages)
        
        stubForSuccessfulItem(.mockArticle2)
        
        //When
        viewModel.fetchNextPage()
        
        //Then
        XCTAssertTrue(viewModel.articles.count == 2)
        XCTAssertTrue(viewModel.state == .complete)
        XCTAssertTrue(!viewModel.hasMorePages)
    }
    
    func testserviceErrorWhenFetching() {
        //Given
        let errorMessage = "Error happened"
        service.stub(for: NewsListRequest.self) {
            Future { promise in
                let error = NewsListError.badRequest(
                    .init(
                        status: .error,
                        code: "Error",
                        message: errorMessage
                    )
                )
                
                promise(.failure(error))
            }
            .eraseToAnyPublisher()
        }
        
        //When
        viewModel.fetchArticles()
        
        //Then
        XCTAssertTrue(viewModel.state == .error(errorMessage))
    }
    
    private func stubForSuccessfulItem(_ item: Article) {
        service.stub(for: NewsListRequest.self) {
            Future { promise in
                let news = NewsList(
                    status: .ok,
                    totalResults: 2,
                    code: nil,
                    message: nil,
                    articles: [item]
                )
                
                promise(.success(news))
            }
            .eraseToAnyPublisher()
        }
    }
}
