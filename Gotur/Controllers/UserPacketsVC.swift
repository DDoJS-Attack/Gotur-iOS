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

class UserPacketsVC: BaseVC, GMSMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    
    var packageTakenList = [Packet]()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addPackage"), for: .normal)
        button.addTarget(self, action: #selector(goToAddPacketVC), for: .touchUpInside)
        return button
    }()
    
    lazy var myPackages : BaseButton = {
        let view =  BaseButton(frame: CGRect(), withColor: UIColor(red: 81/255, green: 68/255, blue: 191/255, alpha: 1.0))
        view.setTitle(myPackagesButtonTitle, for: .normal)
        view.addTarget(self, action: #selector(myPackagesList), for: .touchUpInside)
        return view
    }()
    
    lazy var showPackagesAlert: UIAlertController = {
        let controller = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelButton = UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        var height:NSLayoutConstraint = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.40)
        controller.view.addConstraint(height)
        controller.addAction(cancelButton)
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
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = CGFloat(60.0)
        view.register(MessengerPopupTableViewCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        view.layer.borderWidth = 0.2
        view.layer.cornerRadius = 5
        view.addShadow()
        return view
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
        mapView.settings.myLocationButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        setupMarkersAndLinesBetweenThem(withMap: mapView)
        
        self.view.addSubview(myPackages)
        self.view.addSubview(addButton)
    }
    
    override func setupAnchors() {
        _ = myPackages.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 12, rightConstant: 144, widthConstant: 0, heightConstant: 50)
        _ = addButton.anchor(nil, left: self.myPackages.rightAnchor, bottom: self.view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 17, rightConstant: 0, widthConstant: 40, heightConstant: 40)
    }
    
    override func fetchData() {

        let urlString = "https://chatbot-avci.olut.xyz/cargo"
        let param = ["customer": UID]
        
        Alamofire.request(urlString, method: .post, parameters: param,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let jsonKSwift = JSON(json)
                    let jsonSwiftData = jsonKSwift["data"]
                    for cargo in jsonSwiftData {
                        print(cargo)
                        print("--------------------")
                        let packet = Packet(data: cargo.1)
                        self.packageList.append(packet)
                    }
                    DispatchQueue.main.async {
                        self.setupMarkersAndLinesBetweenThem(withMap: self.mapView)
                    }
                    
                    // Setting up taken package
                    for e in self.packageList{
                        if(e.status == "ASSIGNED" || e.status == "ONWAY"){
                            self.packageTakenList.append(e)
                        }
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
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
        //checkPackageStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func myPackagesList() {
        //It shows current packets for user
        showPackagesAlert.view.addSubview(tableView)
        
        _ = tableView.anchor(self.showPackagesAlert.view.topAnchor, left: self.showPackagesAlert.view.leftAnchor, bottom: self.showPackagesAlert.view.bottomAnchor, right: self.showPackagesAlert.view.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 72, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        self.present(showPackagesAlert, animated: true, completion:{})
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageTakenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MessengerPopupTableViewCell
        //Assigning values to custom cell
        cell.nameLabel.text = packageTakenList[indexPath.item].name
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //adding left pull action
        let drop = UITableViewRowAction(style: .destructive, title: "Dropp") { (action, indexPath) in
            let droppedPackage = self.packageTakenList[indexPath.row]
            self.confirmDrop(withPackage: droppedPackage)
        }
        drop.backgroundColor = UIColor(red: 186.0/255.0, green: 46.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        return [drop]
    }
    
    func confirmDrop(withPackage package: Packet) {
        // Implement
        self.view.shake()
    }
    
    func goToAddPacketVC() {
        let addPacketVC = AddPacketVC()
        present(addPacketVC, animated: true, completion: nil)
    }
}
