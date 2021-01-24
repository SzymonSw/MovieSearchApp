//
//  MovieDetailsViewModel.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import Foundation
import Bond

protocol MovieDetailsDelegate: AnyObject {
    func wantsToGoBack()
}

class MovieDetailsViewModel {
    
    private let requestManager: RequestManager
    private let movieData: MovieData
    unowned let delegate: MovieDetailsDelegate

    var movieDetails = Observable<MovieDetails?>(nil)
    var isLoading = Observable<Bool>(false)
    var error = Observable<MovieAppError?>(nil)

    init(requestManager: RequestManager, movieData: MovieData, delegate: MovieDetailsDelegate) {
        self.requestManager = requestManager
        self.movieData = movieData
        self.delegate = delegate
    }
    
    func viewWillAppear() {
        fetchMovieDetails()
    }
    
    func fetchMovieDetails() {
        self.error.value = nil
        isLoading.value = true
        requestManager.makeRequest(requestData: OMDBApi.movieDetails(movieId: movieData.imdbID), resultType: MovieDetails.self) { (result) in
            self.movieDetails.value = result
            self.isLoading.value = false
            
        } fail: { (error) in
            self.isLoading.value = false
            self.error.value = error
        }
     
    }
    
    func goBack() {
        delegate.wantsToGoBack()
    }

}
