//
//  Packet.swift
//  Gotur
//
//  Created by ismail on 17/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import Foundation

struct Coordinate {
    var longitude: String!
    var latitude: String!
}

class Packet {
    private var _source: Coordinate!
    private var _destination: Coordinate!
    
    var source: Coordinate {
        return _source
    }
    
    var destination: Coordinate {
        return _destination
    }
    
    init(data: Dictionary<String, Any>) {
        if let src = data["source"] as? [String] {
            let coordinate = Coordinate(longitude: src[0], latitude: src[1])
            _source = coordinate
        }
        
        if let dest = data["destination"] as? [String] {
            let coordinate = Coordinate(longitude: dest[0], latitude: dest[1])
            _destination = coordinate
        }
    }
}
