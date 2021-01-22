//
//  MovieData.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 22/01/2021.
//

import Foundation

struct MovieData: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
}
