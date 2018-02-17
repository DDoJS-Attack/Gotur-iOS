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
    
    var packageList = [Packet]()

    
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

        var index = 0
        for p in packageList{
            let sourcePosition = CLLocationCoordinate2D(latitude: p.sourceLoc.latitude, longitude: p.sourceLoc.longitude)
            let sourceMarker = GMSMarker(position: sourcePosition)
            var sourceImageView = UIImageView()
            if(p.status != "INITIAL"){
                sourceImageView = UIImageView(image: UIImage(named: "takenPackage"))
            }else{
                sourceImageView = UIImageView(image: UIImage(named: "nontakenPackage"))
            }
            sourceImageView.tag = index
            sourceMarker.iconView = sourceImageView
            sourceMarker.snippet = "Ağırlık: \(p.weight) kg\nFiyat: \(p.price) tl"
            sourceMarker.title = "\(p.name) - Source"
            sourceMarker.map = mapView
            
            let destinationPosition = CLLocationCoordinate2D(latitude: p.destinationLoc.latitude, longitude: p.destinationLoc.longitude)
            let destinationMarker = GMSMarker(position: destinationPosition)
            destinationMarker.isTappable = false
            destinationMarker.iconView = UIImageView(image: UIImage(named: "destinationPackage"))
            destinationMarker.map = mapView
            
            let path = GMSMutablePath()
            path.add(sourcePosition)
            path.add(destinationPosition)
            let line = GMSPolyline(path: path)
            line.strokeWidth = CGFloat(3)
            line.strokeColor = UIColor(red: 106.0/255.0, green: 111.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            line.map = mapView
            index += 1
        }
        
    }

}

