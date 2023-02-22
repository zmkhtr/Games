//
//  GamesEndpoint.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public enum GamesEndpoint {
    case get(request: GamesRequest)
    
    public func url(baseURL: URL) -> URLRequest {
        switch self {
        case let .get(request):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path
            
            guard let query = request.search else {
                components.queryItems = [
                    URLQueryItem(name: "page", value: "\(request.page)"),
                    URLQueryItem(name: "page_size", value: "\(request.page_size)"),
                ].compactMap { $0 }
                return URLRequest(url: components.url!)
            }
         
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(request.page)"),
                URLQueryItem(name: "page_size", value: "\(request.page_size)"),
                URLQueryItem(name: "search", value: "\(query)"),
            ].compactMap { $0 }
            return URLRequest(url: components.url!)
        }
    }
}
