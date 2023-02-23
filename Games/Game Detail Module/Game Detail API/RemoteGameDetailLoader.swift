//
//  RemoteGameDetailLoader.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public class RemoteGameDetailLoader: GameDetailLoader {
    
    private let url : URL
    private let client: HTTPClient
        
    public typealias Result = GameDetailLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func get(for id: Int, completion: @escaping (Result) -> Void) {
        let request = GameDetailEndpoint.get(id: id).url(baseURL: url)
        client.request(from: request) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteGameDetailLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try GameDetailItemsMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}
