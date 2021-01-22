//
//  MovieSearchResult.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 22/01/2021.
//

import Foundation

struct MovieSearchResult: Codable {
    let search: [MovieData]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
