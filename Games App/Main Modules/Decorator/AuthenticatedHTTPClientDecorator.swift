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
        let key = Bundle.main.infoDictionary! ["API_KEY"] as! String
        request.url?.append(queryItems: [
            URLQueryItem(name: "key", value: key)
        ])
    
        return request
       
    }
}
