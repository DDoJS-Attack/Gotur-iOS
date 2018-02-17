//
//  AddPacketVC.swift
//  Gotur
//
//  Created by ismail on 17/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class AddPacketVC: BaseVC, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, GMSPlacePickerViewControllerDelegate {
    
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    
    var isSource: Bool!
    
    lazy var sourceButton: BaseButton = {
        let view = BaseButton(frame: CGRect(), withColor: primaryDarkColor)
        view.setTitle(enterSourceAddress, for: .normal)
        view.addTarget(self, action: #selector(sourcePicker), for: .touchUpInside)
        return view
    }()
    
    lazy var destinationButton: BaseButton = {
        let view = BaseButton(frame: CGRect(), withColor: primaryDarkColor)
        view.setTitle(enterDestinationAddress, for: .normal)
        view.addTarget(self, action: #selector(destinationPicker), for: .touchUpInside)
        return view
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
        
        placesClient = GMSPlacesClient.shared()
        
        isSource = true
        
        self.view.addSubview(sourceButton)
        self.view.addSubview(destinationButton)
        self.view.addSubview(weightTextField)
        self.view.addSubview(priceTextField)
        self.view.addSubview(saveButton)
        self.view.addSubview(mapView)
        self.view.sendSubview(toBack: mapView)
    }
    
    override func setupAnchors() {
        // TODO: Check wheter those are fits into smaller devices or not
        _ = sourceButton.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: self.view.frame.height/2-84, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 50)
        _ = destinationButton.anchor(self.sourceButton.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 70, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 50)
        _ = weightTextField.anchor(self.destinationButton.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 70, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 33)
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
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                // Error
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.sourceButton.titleLabel?.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
        return true
    }
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        
        if isSource {
            sourceButton.titleLabel?.text = place.formattedAddress?.components(separatedBy: ", ")
                .joined(separator: "\n")
        }
        else {
            destinationButton.titleLabel?.text = place.formattedAddress?.components(separatedBy: ", ")
                .joined(separator: "\n")
        }
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
    func displayPlacePicker() {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func sourcePicker() {
        isSource = true
        displayPlacePicker()
    }
    
    func destinationPicker() {
        isSource = false
        displayPlacePicker()
    }
    
    func savePacket() {
        // Check constraints (Error handling)
        // Push to db
        // Return UserPacketsVC
    }

}
