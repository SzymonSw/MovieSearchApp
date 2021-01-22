//
//  MovieListViewModel.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import Foundation

protocol MovieListDelegate: AnyObject {
    func wantsToShowMovieDetails()
}

class MovieListViewModel {
    
    private let requestManager: RequestManager
    unowned let delegate: MovieListDelegate

    init(requestManager: RequestManager, delegate: MovieListDelegate) {
        self.requestManager = requestManager
        self.delegate = delegate
    }
    
    func didTapNextButton() {
        //delegate.wantsToShowMovieDetails()
        
        let _ = requestManager.makeRequest(requestData: OMDBApi.searchRepositories(query: "bull"), resultType: MovieSearchResult.self) { (movieSearchResult) in
            print(movieSearchResult)
            
        } fail: { (error) in
            print(error)
        }

    }

}
