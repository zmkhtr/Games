//
//  GamesLoader.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public struct GamesRequest: Equatable {
    public var page: Int
    public let page_size: Int
    public var search: String?
    
    public init(page: Int, page_size: Int, search: String? = nil) {
        self.page = page
        self.page_size = page_size
        self.search = search
    }
}

public protocol GamesLoader {
    typealias Result = Swift.Result<[GameItem], Error>
    
    func load(request: GamesRequest, completion: @escaping (Result) -> Void)
}
