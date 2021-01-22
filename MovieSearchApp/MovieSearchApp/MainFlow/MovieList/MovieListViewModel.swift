//
//  MovieListViewModel.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import Foundation
import Bond

protocol MovieListDelegate: AnyObject {
    func wantsToShowMovieDetails()
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

    var currentRequestTask: URLSessionDataTask?
    var reachedEnd = false
    
    
    init(requestManager: RequestManager, delegate: MovieListDelegate) {
        self.requestManager = requestManager
        self.delegate = delegate
    }
    
    func serachTextChanged(newText: String?) {
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
        if (reachedEnd == false) {
            fetchPage()
        }
    }
    
    func didSelectItemAtIndex(index: Int) {
        let movie = moviesList.value[index]
        
    }
    
    @objc func fetchPage() {
        guard let currentQuerry = currentQuerry else {
            return
        }

        isLoading.value = true
        currentRequestTask?.cancel()
        currentRequestTask = requestManager.makeRequest(requestData: OMDBApi.searchRepositories(query: currentQuerry, page: pageNumber), resultType: MovieSearchResult.self) { (movieSearchResult) in
            
            if (movieSearchResult.search.count > 0) {
                self.pageNumber += 1
                self.moviesList.value.append(contentsOf: movieSearchResult.search)
                if self.moviesList.value.count == Int(movieSearchResult.totalResults)! {
                    self.reachedEnd = true
                }
            }
            self.isLoading.value = false

        } fail: { (error) in
            self.isLoading.value = false
            if error != .cancelledRequest {
                self.error.value = error

            }
        
        }
    }
    
    private func resetFetchParams() {
        pageNumber = 1
        reachedEnd = false
        moviesList.value.removeAll()
    }

}
