//
//  UserPacketsVC.swift
//  Gotur
//
//  Created by ismail on 16/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit
import GoogleMaps

class UserPacketsVC: BaseVC {

    override func setupViews() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        //marker.icon = UIImage(named: "house")
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.map = mapView

    }
    
    override func setupAnchors() {
        
    }
    
    override func fetchData() {
        
    }
    

}
