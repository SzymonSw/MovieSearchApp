//
//  MovieDetailsViewModel.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import Foundation
class MovieDetailsViewModel {
    
    private let requestManager: RequestManager
    private let movieData: MovieData
    
    init(requestManager: RequestManager, movieData: MovieData) {
        self.requestManager = requestManager
        self.movieData = movieData
    }

}
