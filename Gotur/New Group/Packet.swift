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
    
    
    init(withData data: Dictionary<String, [Double]>,withName name: String, withWeight weight: String, withPrice price: String) {
        if let src = data["source"]{
            let coordinate = Coordinate(longitude: src[0], latitude: src[1])
            _source = coordinate
        }
        
        if let dest = data["destination"]{
            let coordinate = Coordinate(longitude: dest[0], latitude: dest[1])
            _destination = coordinate
        }
        
        _name = name
        
        _weight = weight
        
        _price = price
    }
}
