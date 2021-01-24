//
//  RequestManager.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//


import Foundation

class OMDBAPIMockHandler: URLMockHandler {
    func handleRequest(request: URLRequest) -> HandledResponse {
        guard let querryParams = request.url?.queryParameters else {
            return HandledResponse(404, nil, URLMockError.badUrlRequest)
        }
        let httpMethod = HTTPMethod(rawValue: request.httpMethod!)
        switch httpMethod {
        case .get:
            if querryParams.contains(where: { (item) -> Bool in
                item.key == "s"}) {
                let responseData = FilesHelper.jsonDataFromFile(filename: "movieSearchGETresponse")!
                return  HandledResponse(200, responseData, nil)

            }
            
            if querryParams.contains(where: { (item) -> Bool in
                item.key == "i"}) {
                let responseData = FilesHelper.jsonDataFromFile(filename: "movieDetailsGETresponse")!
                return  HandledResponse(200, responseData, nil)
            }
            
        default:
            return HandledResponse(404, nil, URLMockError.badUrlRequest)
        }
        return HandledResponse(404, nil, URLMockError.badUrlRequest)

    }
}
