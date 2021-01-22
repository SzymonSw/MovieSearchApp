//
//  RequestManager.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import Foundation

class RequestManager {
    private let session: URLSession
    private let cancelledTaskCode = -999

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }
    
    func makeRequest<T>(requestData: URLRequestConvertible,
                        resultType: T.Type,
                        auth: Bool = true,
                        success: @escaping (T) -> Void,
                        fail: @escaping (MovieAppError) -> Void,
                        eTag: String? = nil,
                        eTagMatch: @escaping (() -> Void) = {}) -> URLSessionDataTask where T: Codable {
        
        let requestDataConverted = requestData.asURLRequest()
        
        let task: URLSessionDataTask = self.session.dataTask(with: requestDataConverted) { (data, response, error) in
            if let nserror = error as NSError?, nserror.code == self.cancelledTaskCode {
                DispatchQueue.main.async {
                    fail(MovieAppError.cancelledRequest)
                }
                return
            }
            
            guard let reponseData = data else {
                DispatchQueue.main.async {
                    fail(MovieAppError.emptyResponseData)
                }
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    fail(MovieAppError.unknowenBackendError)
                }
                return
            }
            
           // let jsonRaw = try? JSONSerialization.jsonObject(with: reponseData) as? [String: Any]
            
            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter.default
            jsonDecoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)
            
            do {
                let parsedResponse = try jsonDecoder.decode(resultType, from: reponseData)
                DispatchQueue.main.async {
                    success(parsedResponse)
                }
                return
                
            } catch (_) {
                DispatchQueue.main.async {
                    fail(MovieAppError.responseParsingError)
                }
                return
            }
            
        }
        task.resume()
        return task
    }
    
}

public protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let get = HTTPMethod(rawValue: "GET")
    public static let head = HTTPMethod(rawValue: "HEAD")
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    public static let patch = HTTPMethod(rawValue: "PATCH")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let trace = HTTPMethod(rawValue: "TRACE")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
