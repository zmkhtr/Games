//
//  LocalImageData.swift
//  Games
//
//  Created by Azam Mukhtar on 23/02/23.
//

import Foundation

public class LocalImageData {
    public var url: URL
    public var data: Data?
    
    public init(url: URL, data: Data?) {
        self.url = url
        self.data = data
    }
    
}
