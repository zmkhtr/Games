//
//  ImageDataCache.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation

public protocol ImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
