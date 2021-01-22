//
//  MovieAppError.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 22/01/2021.
//

import Foundation

enum MovieAppError: String, Error {
    case emptyResponseData
    case responseParsingError
    case unknowenBackendError
    case cancelledRequest
    
    //Errors from OMDB
    case tooManyResults = "Too many results."
    case movieNotFound = "Movie not found!"
    
    var title: String {
        switch self {
        default:
            return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .emptyResponseData:
            return "Response data seems to be empty."
        case .responseParsingError:
            return "Could not parse response data."
        case .unknowenBackendError:
            return "Oops something went wrong, please try again later."
        default:
            return ""
    
        }
    }
}
