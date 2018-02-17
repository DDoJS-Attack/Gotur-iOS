//
//  Packet.swift
//  Gotur
//
//  Created by ismail on 17/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import Foundation

struct Coordinate {
    var longitude: Double!
    var latitude: Double!
}

class Packet {
    private var _source: Coordinate!
    private var _destination: Coordinate!
    private var _name: String!
    private var _weight: String!
    private var _price: String!
    
    
    var source: Coordinate {
        return _source
    }
    
    var destination: Coordinate {
        return _destination
    }
    
    var name: String {
        return _name
    }
    
    var weight: String {
        return _weight
    }
    
    var price: String {
        return _price
    }
    
    // Creating an Packet Object with given parameters
    init(destCoorLat: Double, destCoorLong: Double, sourceCoorLat: Double, sourceCoorLong: Double , name: String,  weight: String,  price: String) {
         _source =  Coordinate(longitude: sourceCoorLat, latitude: sourceCoorLong)
        
        _destination = Coordinate(longitude: destCoorLong, latitude: destCoorLat)
        
        _name = name
        
        _weight = weight
        
        _price = price
    }
    
}
