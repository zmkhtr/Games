//
//  AuthenticatedHTTPClientDecorator.swift
//  Games App
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation
import Games

class AuthenticatedHTTPClientDecorator: HTTPClient {

    private let decoratee: HTTPClient

    init(decoratee: HTTPClient) {
        self.decoratee = decoratee
    }
    
    func request(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> Games.HTTPClientTask {
        decoratee.request(from: enrich(request), completion: completion)
    }
    
    private func enrich(_ request: URLRequest) -> URLRequest {
        var request = request
        request.url?.append(queryItems: [
            URLQueryItem(name: "key", value: "375107cb63db476a86598ff9936da3c4")
        ])
    
        return request
       
    }
}
