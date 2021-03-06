//
//  Packet.swift
//  Gotur
//
//  Created by ismail on 17/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Coordinate {
    var longitude: Double!
    var latitude: Double!
}

class Packet {
    private var _sourceAddress: String!
    private var _destinationAddress: String!
    private var _sourceLoc: Coordinate!
    private var _destinationLoc: Coordinate!
    private var _name: String!
    private var _weight: String!
    private var _price: String!
    private var _id: String!
    private var _status: String!
    private var _courier: String?
    
    var sourceAddress: String {
        return _sourceAddress
    }
    
    var destinationAddress: String {
        return _destinationAddress
    }
    
    var sourceLoc: Coordinate{
        get{
            return _sourceLoc
        }
        set{
            _sourceLoc = newValue
        }
    }
    
    var destinationLoc: Coordinate {
        return _destinationLoc
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
    
    var id: String {
        return _id
    }
    
    var status: String {
        get{
            return  _status
        }
        set{
            _status = newValue
        }
    }
    
    var courier: String? {
        if _courier != nil {
            return _courier
        }
        return nil
    }
    
    init(data: JSON) {
        _sourceAddress = data["sourceAddress"].stringValue
        _destinationAddress = data["destinationAddress"].stringValue
        _sourceLoc = Coordinate(longitude: data["sourceLoc"].arrayValue[0].doubleValue, latitude: data["sourceLoc"].arrayValue[1].doubleValue)
        _destinationLoc = Coordinate(longitude: data["destinationLoc"].arrayValue[0].doubleValue, latitude: data["destinationLoc"].arrayValue[1].doubleValue)
        _name = data["name"].stringValue
        _weight = String(data["weight"].doubleValue)
        _price = String(data["price"].doubleValue)
        _id = data["_id"].stringValue
        _status = data["status"].stringValue
        _courier = data["courier"].stringValue
    }
    
}
