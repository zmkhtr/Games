//
//  ImageDataStore.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation

public protocol ImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ data: LocalImageData, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}
