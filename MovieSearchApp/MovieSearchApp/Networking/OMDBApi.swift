//
//  OMDBApi.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 22/01/2021.
//

import Foundation

enum OMDBApi: URLRequestConvertible {
    case searchMovies(query: String, page: Int)
    case movieDetails(movieId: String)

    static let apiKey = "b9bd48a6"
    
    var method: HTTPMethod {
        switch self {
        case .searchMovies, .movieDetails:
            return .get
            
        }
    }
    
    var host: String {
        return "http://www.omdbapi.com"
    }
    
    var path: String {
        switch self {
        case .searchMovies (let queryString, let page):
            let path = "/?apikey=\(OMDBApi.apiKey)&s=\(queryString)&type=movie&page=\(page)&r=json"
            let escapedurlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return escapedurlString
            
        case .movieDetails (let movieId):
            let path = "/?apikey=\(OMDBApi.apiKey)&i=\(movieId)"
            let escapedurlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return escapedurlString
        }
    }
    
    func asURLRequest() -> URLRequest {
        let urlString = host + path
        let urlRequest = NSMutableURLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .searchMovies, .movieDetails:
            return urlRequest as URLRequest
        
        }
    }
    
}
