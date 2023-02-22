//
//  HTTPClient.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func request(from request : URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
