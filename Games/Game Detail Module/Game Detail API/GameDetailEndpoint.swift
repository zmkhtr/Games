//
//  GameDetailEndpoint.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public enum GameDetailEndpoint {
    case get(id: Int)
    
    public func url(baseURL: URL) -> URLRequest {
        switch self {
        case let .get(id):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/\(id)"
            
            return URLRequest(url: components.url!)
        }
    }
}
