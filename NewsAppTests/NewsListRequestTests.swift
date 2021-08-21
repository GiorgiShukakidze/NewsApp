//
//  NewsListRequestTests.swift
//  NewsAppTests
//
//  Created by Giorgi Shukakidze on 21.08.21.
//

@testable import NewsApp
import XCTest

class NewsListRequestTests: XCTestCase {
    private var request: NewsListRequest!
    
    override func setUp() {
        request = NewsListRequest()
    }
    
    override func tearDown() {
        request = nil
    }
    
    func testBadUrlRequest() {
        //Given
        request.path = "bad path"
        
        //When
        let urlRequest = request.request()
        
        //Then
        XCTAssertNil(urlRequest)
    }
    
    func testGoodUrlRequest() {
        //Given
        request.path = "everything"
        
        //When
        let urlRequest = request.request()
        
        //Then
        XCTAssertNotNil(urlRequest)
        XCTAssertNotNil(urlRequest?.url)
    }
    
    func testMapBadRequestError() {
        //Given
        let error = NetworkError.internalError(400, Data())
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.badRequest(nil))
    }
    
    func testMapUnauthorizedError() {
        //Given
        let error = NetworkError.internalError(401, Data())
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.unauthorized)
    }
    
    func testMapMaxRequestsError() {
        //Given
        let error = NetworkError.internalError(429, Data())
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.maxRequests)
    }
    
    func testMapOtherInternalError() {
        //Given
        let error = NetworkError.internalError(500, Data())
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.other(error.localizedDescription))
    }
    
    func testMapInvalidUrlError() {
        //Given
        let error = NetworkError.invalidRequest
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.invalidURL)
    }
    
    func testMapServerError() {
        //Given
        let error = NetworkError.serverError
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.other(error.localizedDescription))
    }
    
    func testOtherNetworkError() {
        //Given
        let error = NetworkError.other("")
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.other(""))
    }
    
    func testParseError() {
        //Given
        let error = DecodingError.typeMismatch(NewsList.self, .init(codingPath: [], debugDescription: "Decoding error"))
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.parseError(error.localizedDescription))
    }

    func testOtherError() {
        //Given
        let error = MockError.someError
        
        //When
        let requestError = request.mapError(error)
        
        //Then
        XCTAssertEqual(requestError, NewsListError.other(error.localizedDescription))
    }
    
    enum MockError: Error {
        case someError
    }
}
