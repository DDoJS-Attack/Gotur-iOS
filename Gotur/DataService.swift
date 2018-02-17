//
//  DataService.swift
//  Gotur
//
//  Created by ismail on 17/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import Foundation

let DB_BASE = "https://chatbot-avci.olut.xyz"
let DB_ROUTE = DB_BASE + "/"

class DataService {
    
    static let ds = DataService()

    // Cargo
    let REF_CARGO = DB_ROUTE + "cargo"

    // Customer
    let REF_CUSTOMER = DB_ROUTE + "customer"
    let REF_CUSTOMER_MY = DB_ROUTE + "customer/my"
    let REF_CUSTOMER_CREATE = DB_ROUTE + "customer/create"
    let REF_CUSTOMER_DELETE_CARGO = DB_ROUTE + "customer/deleteCargo"
    
    // Courier
    let REF_COURIER = DB_ROUTE + "courier"
    let REF_COURIER_OWN = DB_ROUTE + "courier/own"
    let REF_COURIER_PICK = DB_ROUTE + "courier/pick"
    let REF_COURIER_DELIVER = DB_ROUTE + "courier/deliver"
    let REF_COURIER_RELEASE = DB_ROUTE + "courier/release"
}
