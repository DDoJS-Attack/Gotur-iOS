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
import SocketIO

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
        let cancelButton = UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")
        
        })
        var height:NSLayoutConstraint = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.40)
        controller.view.addConstraint(height)
        controller.addAction(cancelButton)
        return controller
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
        let param = ["customer": UID]
        
        Alamofire.request(DataService.ds.REF_CARGO, method: .post, parameters: param,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let jsonKSwift = JSON(json)
                    let jsonSwiftData = jsonKSwift["data"]
                    for cargo in jsonSwiftData {
                        let packet = Packet(data: cargo.1)
                        self.packageList.append(packet)
                    }
                    
//                    DispatchQueue.main.async {
//                        self.setupMarkersAndLinesBetweenThem(withMap: self.mapView)
//                    }
                    
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
         startSocket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    // When my package delivered 
    // pop up an info alert view
    func startSocket() {
        let socket = SocketIOManager()
        socket.connectToServer { (coordinate) in
            print("Long: \(coordinate.longitude)")
            print("Lat: \(coordinate.latitude)")
            var i = 0
            while i < self.packageList.count{
                if(self.packageList[i].status != "INITIAL"){
                    self.packageList[i].sourceLoc = coordinate
                }
                i += 1
            }
            
            DispatchQueue.main.async{
                self.mapView.clear()
                self.setupMarkersAndLinesBetweenThem(withMap: self.mapView)
                self.mapView.reloadInputViews()
            }
        }
        
    }
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        //checkPackageStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom: userMapViewZoom)
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
        return packageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MessengerPopupTableViewCell
        //Assigning values to custom cell
        cell.nameLabel.text = packageList[indexPath.item].name
        
        // If packet is assigned to courier add icon that indicates this status
        if(packageList[indexPath.item].status == "ASSIGNED" || packageList[indexPath.item].status == "ONWAY" || packageList[indexPath.item].status == "DELIVERY"){
            cell.icon.image = UIImage(named: "courierItself")!
        } else {
            cell.icon.image = UIImage(named: "nontakenPackage")
        }
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //adding left pull action
        if packageList[indexPath.row].status == "INITIAL" {
            // Cancel action
            let cancel = UITableViewRowAction(style: .destructive, title: cancelString) { (action, indexPath) in
                self.confirmCancel(index: indexPath.row)
            }
            cancel.backgroundColor = UIColor(red: 186.0/255.0, green: 46.0/255.0, blue: 88.0/255.0, alpha: 1.0)
            return [cancel]
        }
        return [UITableViewRowAction()]
    }
    
    func confirmCancel(index: Int) {
        // Implement
        let param = ["cargoId": packageList[index].id, "customerId": UID]
        print(param)
        // Remove from db
        Alamofire.request(DataService.ds.REF_CUSTOMER_DELETE_CARGO, method: .delete, parameters: param,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                print("SUCCESS")
            case .failure(let error):
                print(error)
            }
        }
        
        // Remove from packageList
        self.packageList.remove(at: index)
        // Remove markers and lines from map
        self.removePacketFromMap(index: index)
        
        self.tableView.reloadData()
        self.view.shake()
    }
    
    func removePacketFromMap(index: Int) {
        self.srcMarkers[index].map = nil
        self.destMarkers[index].map = nil
        self.polylines[index].map = nil
    }
    
    func goToAddPacketVC() {
        let addPacketVC = AddPacketVC()
        present(addPacketVC, animated: true, completion: nil)
    }
}
