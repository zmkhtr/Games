//
//  GameDetailLoader.swift
//  Games
//
//  Created by Azam Mukhtar on 22/02/23.
//

import Foundation


public protocol GameDetailLoader {
    typealias Result = Swift.Result<GameDetailItem, Error>
    
    func get(for id: Int, completion: @escaping (Result) -> Void)
}
