//
//  AddPacketVC.swift
//  Gotur
//
//  Created by ismail on 17/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit
import GoogleMaps

class AddPacketVC: BaseVC, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    lazy var sourceSearchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect())
        searchBar.placeholder = enterSourceAddress
        searchBar.barTintColor = primaryLightColor
        return searchBar
    }()
    
    lazy var destinationSearchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect())
        searchBar.placeholder = enterDestinationAddress
        searchBar.barTintColor = primaryLightColor
        return searchBar
    }()
    
    lazy var weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = enterWeightOfItem
        textField.font = primaryFont
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextFieldViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        return textField
    }()
    
    lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = enterPriceOfItem
        textField.font = primaryFont
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextFieldViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        return textField
    }()
    
    lazy var saveButton: BaseButton = {
        let view = BaseButton(frame: CGRect(), withColor: primaryDarkColor)
        view.setTitle(saveString, for: .normal)
        view.addTarget(self, action: #selector(savePacket), for: .touchUpInside)
        return view
    }()
    
    override func setupViews() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //view = mapView
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        self.view.addSubview(sourceSearchBar)
        self.view.addSubview(destinationSearchBar)
        self.view.addSubview(weightTextField)
        self.view.addSubview(priceTextField)
        self.view.addSubview(saveButton)
        self.view.addSubview(mapView)
        self.view.sendSubview(toBack: mapView)
    }
    
    override func setupAnchors() {
        // TODO: Check wheter those are fits into smaller devices or not
        _ = sourceSearchBar.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: self.view.frame.height/2-84, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 50)
        _ = destinationSearchBar.anchor(self.sourceSearchBar.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 70, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 50)
        _ = weightTextField.anchor(self.destinationSearchBar.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 70, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 33)
        _ = priceTextField.anchor(self.weightTextField.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 50, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 33)
        _ = saveButton.anchor(self.priceTextField.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 50, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 50)
       
        _ = mapView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: self.view.frame.width, heightConstant: 250)
    }
    
    override func fetchData() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = primaryLightColor
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        sourceSearchBar.text = "My location"
        return true
    }
    
    func savePacket() {
        // Check constraints (Error handling)
        // Push to db
        // Return UserPacketsVC
    }

}
