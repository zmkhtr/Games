//
//  HTTPClientSpy.swift
//  GamesTests
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation
import Games

class HTTPClientSpy: HTTPClient {
    
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() { callback() }
    }
    
    private var messages = [(requests: URLRequest, completion: (HTTPClient.Result) -> Void)]()
    private(set) var cancelledURLs = [URL]()
    
    var requestedURLs: [URL] {
        return messages.compactMap { $0.requests.url }
    }
    
    func request(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((request, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(request.url!)
        }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}
