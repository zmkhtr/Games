//
//  AllGamesDetailLoader.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation

public protocol AllGamesDetailLoader {
    typealias Result = Swift.Result<[GameDetailItem], Error>
    
    func getAll(completion: @escaping (Result) -> Void)
}
