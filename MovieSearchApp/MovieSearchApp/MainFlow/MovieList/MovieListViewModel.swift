//
//  MovieListViewModel.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import Foundation
import Bond

protocol MovieListDelegate: AnyObject {
    func wantsToShowMovieDetails(movieData: MovieData)
}

class MovieListViewModel: NSObject {
    
    private let requestManager: RequestManager
    unowned let delegate: MovieListDelegate
    
    private var currentQuerry:String?
    private var pageNumber = 1
    private let itemsPerPage = 25
    private let nextQuerryDelay: TimeInterval = 0.5
    
    var moviesList = Observable<[MovieData]>([])
    var isLoading = Observable<Bool>(false)
    var error = Observable<MovieAppError?>(nil)
    var reachedEnd = Observable<Bool>(false)

    var currentRequestTask: URLSessionDataTask?
    
    init(requestManager: RequestManager, delegate: MovieListDelegate) {
        self.requestManager = requestManager
        self.delegate = delegate
    }
    
    func serachTextChanged(newText: String?) {
        if newText == currentQuerry {
            return
        }
        resetFetchParams()

        if (newText == nil || newText! == "") {
            currentQuerry = nil

        } else {
            currentQuerry = newText
            
            //delay fetch as user may type longer word (to reduce number of queries)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchPage), object: nil)
            perform(#selector(fetchPage), with: nil, afterDelay: nextQuerryDelay)
            
        }
        
    }
    
    func scrolledToEndOfList() {
        if (reachedEnd.value == false) {
            fetchPage()
        }
    }
    
    func didSelectItemAtIndex(index: Int) {
        let movie = moviesList.value[index]
        delegate.wantsToShowMovieDetails(movieData: movie)
        
    }
    
    @objc func fetchPage() {
        guard let currentQuerry = currentQuerry else {
            return
        }

        isLoading.value = true
        self.error.value = nil
        currentRequestTask?.cancel()
        currentRequestTask = requestManager.makeRequest(requestData: OMDBApi.searchRepositories(query: currentQuerry, page: pageNumber), resultType: MovieSearchResult.self) { (movieSearchResult) in
            self.isLoading.value = false

            guard movieSearchResult.response == "True",
                  let searchItems = movieSearchResult.search,
                  let totalResultsString = movieSearchResult.totalResults,
                  let totalResults = Int(totalResultsString) else {
                
                if let errorText = movieSearchResult.error, let parsedError = MovieAppError(rawValue: errorText) {
                    self.error.value = parsedError
                } else {
                    self.error.value = .unknowenBackendError
                }
                return
            }

            if (searchItems.count > 0) {
                self.pageNumber += 1
                self.moviesList.value.append(contentsOf: searchItems)
                if self.moviesList.value.count == totalResults {
                    self.reachedEnd.value = true
                }
            }

        } fail: { (error) in
            self.isLoading.value = false
            if error != .cancelledRequest {
                self.error.value = error

            }
        
        }
    }
    
    private func resetFetchParams() {
        pageNumber = 1
        reachedEnd.value = false
        moviesList.value.removeAll()
    }

}
