//
//  MovieDetailsViewModel.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import Foundation
import Bond

class MovieDetailsViewModel {
    
    private let requestManager: RequestManager
    private let movieData: MovieData
    
    var movieDetails = Observable<MovieDetails?>(nil)
    var isLoading = Observable<Bool>(false)
    var error = Observable<MovieAppError?>(nil)

    init(requestManager: RequestManager, movieData: MovieData) {
        self.requestManager = requestManager
        self.movieData = movieData
    }
    
    func viewWillAppear() {
        fetchMovieDetails()
    }
    
    func fetchMovieDetails() {
        isLoading.value = true
        self.error.value = nil
        requestManager.makeRequest(requestData: OMDBApi.movieDetails(movieId: movieData.imdbID), resultType: MovieDetails.self) { (result) in
            self.movieDetails.value = result
            self.isLoading.value = false
            
        } fail: { (error) in
            self.isLoading.value = false
            self.error.value = error
        }
     
    }

}
