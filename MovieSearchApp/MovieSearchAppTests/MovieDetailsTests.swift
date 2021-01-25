//
//  MovieSearchAppTests.swift
//  MovieSearchAppTests
//
//  Created by Szymon Świętek on 24/01/2021.
//

import XCTest
@testable import MovieSearchApp

class MovieDetailsTests: XCTestCase {
    
    var viewModel: MovieDetailsViewModel!
    
    var wantsToGoBack_called = false
    
    override func setUpWithError() throws {
        URLProtocolMock.requestHandler = OMDBAPIMockHandler()
        URLProtocolMock.requestDelay = 0.0
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        let reqManager = RequestManager(session: session)
        let movieData = MovieData(title: "test", year: "2000", imdbID: "tt1111", type: .movie, poster: "N/A")
        viewModel = MovieDetailsViewModel(requestManager: reqManager, movieData: movieData, delegate: self)
    }

    func testDetailsFetch() throws {
        viewModel.viewWillAppear()
        
        let exp = expectation(description: "Wait for mock call to finish")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.8)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(viewModel.movieDetails.value != nil, "Movie details should be fetched after view will appear.")
        } else {
            XCTFail("Mock call should be finished by now.")
        }
    }
    
    func testGoBack() throws {
        viewModel.goBack()
        XCTAssert(wantsToGoBack_called, "After user taps on go back - delegate method should be called.")

    }

}


extension MovieDetailsTests: MovieDetailsDelegate {
    func wantsToGoBack() {
        wantsToGoBack_called = true
    }
}
