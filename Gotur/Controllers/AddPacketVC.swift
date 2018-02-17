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


class AddPacketVC: BaseVC, CLLocationManagerDelegate, UISearchBarDelegate, GMSPlacePickerViewControllerDelegate {

    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    
    var isSource: Bool!
    
    lazy var navBar: UIView = {
        let view = UIView()
        view.backgroundColor = primaryDarkColor
        return view
    }()

    
    lazy var cancelButton: BaseButton = {
        let button = BaseButton(frame: CGRect(), withColor: primaryDarkColor)
        button.setTitle(cancelString, for: .normal)
        button.titleLabel?.font = primaryFont
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var sourceButton: BaseButton = {
        let button = BaseButton(frame: CGRect(), withColor: primaryDarkColor)
        button.setTitle(clickToEnterSourceAddress, for: .normal)
        button.titleLabel?.font = primaryFont
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.addTarget(self, action: #selector(sourcePlacePicker), for: .touchUpInside)
        return button
    }()
    
    lazy var destinationButton: BaseButton = {
        let button = BaseButton(frame: CGRect(), withColor: primaryDarkColor)
        button.setTitle(clickToEnterDestinationAddress, for: .normal)
        button.titleLabel?.font = primaryFont
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.addTarget(self, action: #selector(destinationPlacePicker), for: .touchUpInside)
        return button
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

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = enterNameOfItem
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
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        placesClient = GMSPlacesClient.shared()
        
        isSource = true
        
        self.view.backgroundColor = primaryLightColor
        
        self.navBar.addSubview(cancelButton)
        self.view.addSubview(navBar)
        self.view.addSubview(sourceButton)
        self.view.addSubview(destinationButton)
        self.view.addSubview(weightTextField)
        self.view.addSubview(priceTextField)
        self.view.addSubview(saveButton)
        self.view.addSubview(nameTextField)
    }
    
    override func setupAnchors() {
        // TODO: Check wheter those are fits into smaller devices or not
        _ = navBar.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: self.view.frame.width, heightConstant: 60)
        _ = cancelButton.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 40)
        _ = sourceButton.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: self.view.frame.height/4, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = destinationButton.anchor(self.sourceButton.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 60, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = weightTextField.anchor(self.destinationButton.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 60, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = priceTextField.anchor(self.weightTextField.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 60, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = nameTextField.anchor(self.priceTextField.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 60, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = saveButton.anchor(self.nameTextField.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 60, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 40)
    }
    
    
    override func fetchData() {
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = primaryLightColor
    }
    
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
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func displayPlacePicker() {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func sourcePlacePicker() {
        isSource = true
        displayPlacePicker()
    }
    
    func destinationPlacePicker() {
        isSource = false
        displayPlacePicker()
    }
    
    func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePacket() {
        // Check constraints (Error handling)
        // Push to db
        // Return UserPacketsVC
        self.dismiss(animated: true, completion: nil)
    }

}
