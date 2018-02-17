//
//  UserPacketsVC.swift
//  Gotur
//
//  Created by ismail on 16/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import StarReview

class UserPacketsVC: BaseVC, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addPackage"), for: .normal)
        button.addTarget(self, action: #selector(goToAddPacketVC), for: .touchUpInside)
        return button
    }()
    
    
    lazy var showPackagesAlert: UIAlertController = {
        let controller = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        let okayButton = UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: { action in
            self.sendStars()
        })
        var height:NSLayoutConstraint = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.20)
        controller.view.addConstraint(height)
        controller.addAction(cancelButton)
        controller.addAction(okayButton)
        return controller
    }()

    lazy var starView: StarReview = {
        let star = StarReview()
        star.starMarginScale = 0.3
        star.value = 5
        star.starCount = 5
        star.allowEdit = true
        star.allowAccruteStars = true
        
        star.starFillColor = UIColor.orange
        star.starBackgroundColor = UIColor.lightGray
        return star
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .white
    }

    override func setupViews() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        setupMarkersAndLinesBetweenThem(withMap: mapView)
        
        self.view.addSubview(addButton)
    }
    
    override func setupAnchors() {
        _ = addButton.anchor(nil, left: nil, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 36, rightConstant: 12, widthConstant: 60, heightConstant: 60)
    }
    
    override func fetchData() {
    }
    
    func checkPackageStatus(){
        if(checkIfPackageDropredOrNot()){
            showPackagesAlert.title = "Fish has been dropped"
            showPackagesAlert.view.addSubview(starView)
            
            _ = starView.anchor(self.showPackagesAlert.view.topAnchor, left: self.showPackagesAlert.view.leftAnchor, bottom: self.showPackagesAlert.view.bottomAnchor, right: self.showPackagesAlert.view.rightAnchor, topConstant: 48, leftConstant: 8, bottomConstant: 48, rightConstant: 8, widthConstant: 0, heightConstant: 0)
            
            self.present(showPackagesAlert, animated: true, completion:{})
        }
    }
    func sendStars() {
        // Send stars to database
        print("current Start Value \(starView.value)")
    }
    func checkIfPackageDropredOrNot() -> Bool {
        // Implement this
        return true
    }
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        checkPackageStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    func goToAddPacketVC() {
        let addPacketVC = AddPacketVC()
        present(addPacketVC, animated: true, completion: nil)
    }
}
