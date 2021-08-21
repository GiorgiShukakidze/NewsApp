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
        stubForSuccessfulItem(
            Article(
                title: "Lore ipsum",
                description: nil,
                publishedAt: Date(),
                urlString: "http://lorem.com/ipsum",
                imageUrlString: nil
            )
        )
        
        //When
        viewModel.fetchArticles()
        
        //Then
        XCTAssertTrue(viewModel.articles.count == 1)
        XCTAssertEqual(viewModel.state, .complete)
    }
    
    func testfetchNextPage() {
        //Given
        stubForSuccessfulItem(
            Article(
                title: "Lore ipsum",
                description: nil,
                publishedAt: Date(),
                urlString: "http://lorem.com/ipsum",
                imageUrlString: nil
            )
        )
        viewModel.fetchArticles()
        XCTAssertTrue(viewModel.hasMorePages)
        
        stubForSuccessfulItem(
            Article(
                title: "Lore ipsum 2",
                description: nil,
                publishedAt: Date(),
                urlString: "http://lorem.com/ipsum2",
                imageUrlString: nil
            )
        )
        
        //When
        viewModel.fetchNextPage()
        
        //Then
        XCTAssertTrue(viewModel.articles.count == 2)
        XCTAssertTrue(viewModel.state == .complete)
        XCTAssertTrue(!viewModel.hasMorePages)
    }
    
    func testserviceErrorWhenFetching() {
        //Given
        service.stub(for: NewsListRequest.self) {
            Future { promise in
                let error = NewsListError.badRequest(
                    .init(
                        status: .error,
                        code: "Error",
                        message: "Error happened"
                    )
                )
                
                promise(.failure(error))
            }
            .eraseToAnyPublisher()
        }
        
        //When
        viewModel.fetchArticles()
        
        //Then
        XCTAssertTrue(viewModel.showError == true)
        XCTAssertTrue(!viewModel.errorMessage.isEmpty)
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
