//
//  SocketIOManager.swift
//  Gotur
//
//  Created by Sadik Ekin Ozbay on 18.02.2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: "http://5eee7137.ngrok.io:80")!, config: [.log(false), .compress])
    
    var coordinate =  Coordinate()
    
    override init() {
        super.init()

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("broadcast") {data, ack in
            if let lat = Double(JSON(data[0])["lat"].stringValue) {
                 self.coordinate.latitude = lat
            }
            if let long = Double(JSON(data[0])["lon"].stringValue) {
                self.coordinate.longitude = long
            }
            print("data2: \(JSON(data[0])["lat"])")
            print("data2: \(JSON(data[0])["lon"])")
            
            
        }
        
        socket.connect()
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

