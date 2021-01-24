//
//  RequestManager.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import Foundation

enum URLMockError: Error {
    case jsonFileOpenError
    case jsonFileFormattingError
    case badUrlRequest
    case intentionalErrorResponse

}

typealias ResultType = Result<Data, Error> //from swift 5

class URLProtocolMock: URLProtocol {
    
    static var requestHandler: URLMockHandler!
    static var requestDelay: TimeInterval = 0.5
    
    // MARK: Overrides

    private(set) var activeTask: URLSessionTask?
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        perform(#selector(continueTask), with: nil, afterDelay: URLProtocolMock.requestDelay)
    }
    
    @objc func continueTask() {
        self.activeTask = self.session.dataTask(with: self.request)
        self.activeTask?.cancel()
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
    
}

extension URLProtocolMock: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let mockedResult = URLProtocolMock.requestHandler.handleRequest(request: task.currentRequest!)
        
        let response = HTTPURLResponse(url: task.currentRequest!.url!, statusCode: mockedResult.statusCode, httpVersion: nil, headerFields: nil)!
        if let data = mockedResult.data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let error = mockedResult.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
        
    }
   
}

typealias HandledResponse = (statusCode: Int, data: Data?, error: Error?)

protocol URLMockHandler {
    func handleRequest(request: URLRequest) -> HandledResponse
}

extension Data {
    init(reading input: InputStream) throws {
        self.init()
        input.open()
        defer {
            input.close()
        }
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
        }
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read < 0 {
                //Stream error occured
                throw input.streamError!
            } else if read == 0 {
                //EOF
                break
            }
            self.append(buffer, count: read)
        }
    }
}
