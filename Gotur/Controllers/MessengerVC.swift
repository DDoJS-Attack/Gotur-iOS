//
//  MessengerVC.swift
//  Gotur
//
//  Created by Sadik Ekin Ozbay on 16.02.2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SocketIO

class MessengerVC: BaseVC, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var currentLocation = Coordinate()
    
    var packageTakenList = [Packet]()
    
    var locationManager = CLLocationManager()
    
    lazy var myPackages : BaseButton = {
        let view =  BaseButton(frame: CGRect(), withColor: UIColor(red: 81/255, green: 68/255, blue: 191/255, alpha: 1.0))
        view.setTitle(myPackagesButtonTitle, for: .normal)
        view.addTarget(self, action: #selector(myPackagesList), for: .touchUpInside)
        return view
    }()
    
    // Variable for creating an alert with tableview
    lazy var showPackagesAlert: UIAlertController = {
        let controller = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelButton = UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
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
    
    lazy var mapView : GMSMapView = {
        let view = GMSMapView()
        view.isMyLocationEnabled = true
        return view
    }()
    
    override func fetchData() {
        // Parse already assigned packets
        // TODO: Test this function
        // let param = ["customer": CID]
        /*
        Alamofire.request(DataService.ds.REF_CARGO, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let jsonKSwift = JSON(json)
                    let jsonSwiftData = jsonKSwift["data"]
                    var i = 0
                    // While data is not null append values to charity array that will be used for tableview
                    while(jsonSwiftData[i] != JSON.null){
                        let tempPacket = self.packetCreator(withJSONData: jsonSwiftData[i])
                        self.packageList.append(tempPacket)
                        i += 1
                    }
                    DispatchQueue.main.async {
                        self.setupMarkersAndLinesBetweenThem(withMap: self.mapView)
                    }
                }
                
                // Setting up taken package
                for e in self.packageList{
                    if(e.status == "ASSIGNED" || e.status == "ONWAY" || e.status == "DELIVERY"){
                        self.packageTakenList.append(e)
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }*/
        startSocket()
    }
    
    func startSocket() {
        var socket = SocketIOManager()
        socket.establishConnection()
    }
    
    func packetCreator(withJSONData jsonSwiftData : JSON) -> Packet{
        return Packet.init(data: jsonSwiftData)
    }
    
    override func setupViews() {
        self.view.addSubview(mapView)
        self.mapView.addSubview(myPackages)
        
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
    }
    
    override func setupAnchors() {
        _ = mapView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = myPackages.anchor(nil, left: nil, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 24, rightConstant: 24, widthConstant: self.view.frame.width/2, heightConstant: self.view.frame.height/12)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .white
    }
    
    func myPackagesList() {
        //It shows current packets for user
        showPackagesAlert.view.addSubview(tableView)
        
        _ = tableView.anchor(self.showPackagesAlert.view.topAnchor, left: self.showPackagesAlert.view.leftAnchor, bottom: self.showPackagesAlert.view.bottomAnchor, right: self.showPackagesAlert.view.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 72, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        self.present(showPackagesAlert, animated: true, completion:{})
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // getting current location
        currentLocation.longitude = (locations.last?.coordinate.longitude)!
        currentLocation.latitude = (locations.last?.coordinate.latitude)!
        let camera = GMSCameraPosition.camera(withLatitude:  currentLocation.latitude, longitude:  currentLocation.longitude, zoom: courierMapViewZoom)
        mapView.animate(to: camera)
        
        fetchNearPackets()
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func fetchNearPackets() {
        // Parsing datas from api
        // Courier can only see packets that has a status of INITIAL, that means no one took it,
        // and packets in the radius of 20km
        // "status": ["INITIAL"] add and test
        let params = [
                      "near": ["latitude": currentLocation.latitude, "longitude": currentLocation.longitude, "radius": range]
                    ] as [String : Any]
        
        Alamofire.request(DataService.ds.REF_CARGO, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let jsonKSwift = JSON(json)
                    let jsonSwiftData = jsonKSwift["data"]
                    var i = 0
                    // While data is not null append values to charity array that will be used for tableview
                    while(jsonSwiftData[i] != JSON.null){
                        let tempPacket = self.packetCreator(withJSONData: jsonSwiftData[i])
                        self.packageList.append(tempPacket)
                        i += 1
                    }
                    DispatchQueue.main.async {
                        self.setupMarkersAndLinesBetweenThem(withMap: self.mapView)
                    }
                }
                
                // Setting up taken package
                for e in self.packageList{
                    if(e.status == "ASSIGNED" || e.status == "ONWAY" || e.status == "DELIVERY"){
                        self.packageTakenList.append(e)
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // When user tapped to marker, it runs this code
        if (self.packageList[marker.iconView!.tag].status == "INITIAL") {
            let alert = UIAlertController(title: packageString, message: doYouWantToTakeThisPacket, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: cancelString, style: UIAlertActionStyle.cancel, handler: nil)
            let okayButton = UIAlertAction(title: okString, style: .default) { (alert) in
                let location = marker.iconView!.tag
                // Update in database
                let packet: Dictionary<String, String> = [
                    "cargoId": String(describing: self.packageList[location].id),
                    "courierId": CID
                ]
                print(packet)
                // Push to db
                Alamofire.request(DataService.ds.REF_COURIER_OWN, method: .post, parameters: packet,encoding: JSONEncoding.default, headers: nil).responseString {
                    response in
                    switch response.result {
                    case .success:
                        print(response)
                        self.packageTakenList.append(self.packageList[location])
                        marker.iconView = UIImageView(image: UIImage(named: "courierItself"))
                        self.packageList.remove(at: location)
                        self.tableView.reloadData()
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            alert.addAction(cancelButton)
            alert.addAction(okayButton)
            present(alert, animated: true, completion: nil)
        }
        return true
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
        let drop = UITableViewRowAction(style: .destructive, title: "Delivered") { (action, indexPath) in
            let droppedPackage = self.packageTakenList[indexPath.row]
            self.confirmDrop(withPackage: droppedPackage)
        }
        drop.backgroundColor = UIColor(red: 186.0/255.0, green: 46.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        return [drop]
    }
    
    func confirmDrop(withPackage package: Packet) {

        if(findDistanceBetweenTwoLocations(package.destinationLoc, currentLocation) <= 0){
            // Update in database
            let packet: Dictionary<String, String> = [
                "cargoId": String(describing: package.id),
            ]
            print(packet)
            // Push to db
            Alamofire.request(DataService.ds.REF_COURIER_DELIVER, method: .post, parameters: packet,encoding: JSONEncoding.default, headers: nil).responseString {
                response in
                switch response.result {
                case .success:
                    print(response)
                    self.packageTakenList = self.packageTakenList.filter { $0.id != package.id }
                    self.tableView.reloadData()
                case .failure(let error):
                    
                    print(error)
                }
            }
            print("Package delivered")
        }else {
            self.view.shake()
        }
    }
    
    func findDistanceBetweenTwoLocations(_ locationOne: Coordinate, _ locationTwo: Coordinate) -> Double{
        let differenceLatitude = abs(abs(locationOne.latitude)-abs(locationTwo.latitude))
        let differenceLongtitude = abs(abs(locationOne.longitude)-abs(locationTwo.longitude))
        
        return  (differenceLatitude*differenceLatitude + differenceLongtitude*differenceLongtitude).squareRoot()
    }
}
