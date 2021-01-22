//
//  OMDBApi.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 22/01/2021.
//

import Foundation

enum OMDBApi: URLRequestConvertible {
    case searchRepositories(query: String, page: Int)
    
    static let apiKey = "b9bd48a6"

    var encoder: JSONEncoder {
        let dateFormatter = DateFormatter.default
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchRepositories:
            return .get
        }
    }
    
    var host: String {
        return "http://www.omdbapi.com"
    }
    
    var path: String {
        switch self {
        case .searchRepositories (let queryString, let page):
            let path = "/?apikey=\(OMDBApi.apiKey)&s=\(queryString)&type=movie&page=\(page)&r=json"
            let escapedurlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return escapedurlString

        }
    }
    
    func asURLRequest() -> URLRequest {
        let urlString = host + path
        let urlRequest = NSMutableURLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .searchRepositories:
            return urlRequest as URLRequest
        
        }
    }
    
}
