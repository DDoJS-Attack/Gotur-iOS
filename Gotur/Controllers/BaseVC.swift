//
//  BaseVC.swift
//  Gotur
//
//  Created by Sadik Ekin Ozbay on 16.02.2018.
//  Copyright © 2018 Sadik Ekin Ozbay. All rights reserved.
//

import UIKit
import GoogleMaps


class BaseVC: UIViewController {
    // This is the base View Controller. It will be the parent Class of every controller.
    
    let packageList = [Packet.init(withData: ["source": [-122.448586,   37.793414], "destination": [-123.408586, 38.793414]], withName: "Fish", withWeight: "100", withPrice: "30"),Packet.init(withData: ["source": [-122.408586, 37.795914], "destination": [-122.408586,   37.781414]], withName: "Honey", withWeight: "10", withPrice: "100"), Packet.init(withData: ["source": [-122.408586, 35.793414], "destination": [-123.408586, 37.793414]], withName: "Pen", withWeight: "20", withPrice: "20"),    Packet.init(withData: ["source": [-121.408586, 35.793414], "destination": [-123.408586, 34.793414]], withName: "Paper", withWeight: "10", withPrice: "60")  ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        fetchData()
        setupViews()
        setupAnchors()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // It is responsible for creating the views
    func setupViews(){
        
    }
    
    // It is responsible for setting up the anchors
    func setupAnchors(){

    }
    
    //API works will be in this function
    func fetchData(){
 
    }
    
    func setupMarkersAndLinesBetweenThem(withMap mapView: GMSMapView) {
        
        // Creating a marker for every item in the list and connects them
        for p in packageList{
            let sourcePosition = CLLocationCoordinate2D(latitude: p.source.latitude, longitude: p.source.longitude)
            let sourceMarker = GMSMarker(position: sourcePosition)
            sourceMarker.icon = UIImage(named: "transportablePackage")
            sourceMarker.snippet = "Ağırlık: \(p.weight) kg\nFiyat: \(p.price) tl"
            sourceMarker.title = "\(p.name) - Source"
            sourceMarker.map = mapView
            
            let destinationPosition = CLLocationCoordinate2D(latitude: p.destination.latitude, longitude: p.destination.longitude)
            let destionationMarker = GMSMarker(position: destinationPosition)
            destionationMarker.icon = UIImage(named: "destinationPackage")
            destionationMarker.snippet = "Ağırlık: \(p.weight) kg\nFiyat: \(p.price) tl"
            destionationMarker.title = "\(p.name) - Dest"
            destionationMarker.map = mapView
            
            let path = GMSMutablePath()
            path.add(sourcePosition)
            path.add(destinationPosition)
            let line = GMSPolyline(path: path)
            line.strokeWidth = CGFloat(3)
            line.strokeColor = UIColor(red: 193.0/255.0, green: 180.0/255.0, blue: 81.0/255.0, alpha: 0.7)
            line.map = mapView
        }
        
    }

}

