//
//  MovieSearchAppTests.swift
//  MovieSearchAppTests
//
//  Created by Szymon Świętek on 24/01/2021.
//

import XCTest
@testable import MovieSearchApp

class MovieSearchAppTests: XCTestCase {
    
    var viewModel: MovieListViewModel!
    
    var wantsToShowDetails_called = false
    
    override func setUpWithError() throws {
        URLProtocolMock.requestHandler = OMDBAPIMockHandler()
        URLProtocolMock.requestDelay = 0.0
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        let reqManager = RequestManager(session: session)
        viewModel = MovieListViewModel(requestManager: reqManager, delegate: self)
    }

    func testTextInputChanged() throws {
        viewModel.searchTextChanged(newText: "Marvel")
        
        let exp = expectation(description: "Wait for mock call to finish")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.8)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(viewModel.moviesList.count == 10, "Items should be fetched from backend and parsed when user changes text.")
        } else {
            XCTFail("Mock call should be finished by now.")
        }
    }

}


extension MovieSearchAppTests: MovieListDelegate {
    func wantsToShowMovieDetails(movieData: MovieData) {
        wantsToShowDetails_called = true
    }
    
}
