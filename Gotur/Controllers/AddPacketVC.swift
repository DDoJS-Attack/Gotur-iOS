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
import Alamofire

class AddPacketVC: BaseVC, CLLocationManagerDelegate, UISearchBarDelegate, GMSPlacePickerViewControllerDelegate {

    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    
    var isSource: Bool!
    var source: GMSPlace!
    var destination: GMSPlace!
    
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
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
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
        let button = BaseButton(frame: CGRect(), withColor: primaryDarkColor)
        button.setTitle(saveString, for: .normal)
        button.titleLabel?.font = primaryFont
        button.addTarget(self, action: #selector(savePacket), for: .touchUpInside)
        return button
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
        _ = nameTextField.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: self.view.frame.height / 4, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = sourceButton.anchor(self.nameTextField.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = destinationButton.anchor(self.sourceButton.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = weightTextField.anchor(self.destinationButton.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = priceTextField.anchor(self.weightTextField.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 250, heightConstant: 40)
        _ = saveButton.anchor(self.priceTextField.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 40)
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
            source = place
        }
        else {
            destinationButton.titleLabel?.text = place.formattedAddress?.components(separatedBy: ", ")
                .joined(separator: "\n")
            destination = place
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
        if isSatisfied() {
            // Initialize packet JSON
            let packet: Dictionary<String, Any> = [
                "name": nameTextField.text!,
                "sourceAddress": source.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") as AnyObject,
                "destinationAddress": destination.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") as AnyObject,
                "sourceLoc": [source.coordinate.longitude, source.coordinate.latitude],
                "destinationLoc": [destination.coordinate.longitude, destination.coordinate.latitude],
                "owner": UID,
                "price": calculatePriceAsKurus(price: priceTextField.text!),
                "weight": Double(weightTextField.text!) as AnyObject
            ]
            print(packet)
            // Push to db
            let urlString = "https://chatbot-avci.olut.xyz/customer/create"
            
            Alamofire.request(urlString, method: .post, parameters: packet,encoding: JSONEncoding.default, headers: nil).responseString {
                response in
                switch response.result {
                case .success:
                    print(response)
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }
            }
            // Return UserPacketsVC
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func calculatePriceAsKurus(price: String) -> Double {
        if let price = Double(price) {
            return Double(price) * 60.0
        }
        
        return 0.0
    }
    
    func alertDisplay(title: String, message: String?, buttonTitle: String, buttonStyle: UIAlertActionStyle, sender: UIViewController?) -> UIAlertController{
        
        let alert = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle, handler: nil))
        
        return alert
    }
    
    func isSatisfied() -> Bool {
        guard let name = nameTextField.text, !name.isEmpty else {
            // Display error
            self.present(alertDisplay(title: errorEmptyName, message: "", buttonTitle: okString, buttonStyle: UIAlertActionStyle.default, sender: nil), animated: true, completion: nil)
            return false
        }
        
        guard let nameTemp = nameTextField.text, nameTemp.characters.count >= 3, nameTemp.characters.count < 24  else {
            self.present(alertDisplay(title: errorCharacterCount3To24, message: "", buttonTitle: okString, buttonStyle: UIAlertActionStyle.default, sender: nil), animated: true, completion: nil)
            return false
        }
        
        guard let _ = source else {
            // Display error
            self.present(alertDisplay(title: errorSourceAddress, message: "", buttonTitle: okString, buttonStyle: UIAlertActionStyle.default, sender: nil), animated: true, completion: nil)
            return false
        }
        
        guard let _ = destination else {
            // Display error
            self.present(alertDisplay(title: errorDestinationAddress, message: "", buttonTitle: okString, buttonStyle: UIAlertActionStyle.default, sender: nil), animated: true, completion: nil)
            return false
        }
        
        guard let weight = weightTextField.text, !weight.isEmpty else {
            // Display error
            self.present(alertDisplay(title: errorEmptyWeight, message: "", buttonTitle: okString, buttonStyle: UIAlertActionStyle.default, sender: nil), animated: true, completion: nil)
            return false
        }
        
        guard let weightTemp = weightTextField.text, Double(weightTemp) != nil else {
            self.present(alertDisplay(title: errorIncorrectWeight, message: "", buttonTitle: okString, buttonStyle: UIAlertActionStyle.default, sender: nil), animated: true, completion: nil)
            return false
        }
        
        guard let price = priceTextField.text, !price.isEmpty else {
            // Display error
            self.present(alertDisplay(title: errorEmptyPrice, message: "", buttonTitle: okString, buttonStyle: UIAlertActionStyle.default, sender: nil), animated: true, completion: nil)
            return false
        }
        
        guard let priceTemp = priceTextField.text, Double(priceTemp) != nil else {
            // Display error
            self.present(alertDisplay(title: errorIncorrectPrice, message: "", buttonTitle: okString, buttonStyle: UIAlertActionStyle.default, sender: nil), animated: true, completion: nil)
            return false
        }
        
        return true
    }

}
