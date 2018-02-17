//
//  MessengerVC.swift
//  Gotur
//
//  Created by Sadik Ekin Ozbay on 16.02.2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import UIKit
import GoogleMaps
//import PopupDialog

class MessengerVC: BaseVC, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var currentLocation = Coordinate()
    
    var locationManager = CLLocationManager()
    
    lazy var myPackages : BaseButton = {
        let view =  BaseButton(frame: CGRect(), withColor: UIColor(red: 81/255, green: 68/255, blue: 191/255, alpha: 1.0))
        view.setTitle(myPackagesButtonTitle, for: .normal)
        view.addTarget(self, action: #selector(myPackagesList), for: .touchUpInside)
        return view
    }()
    
    let packageList = [Packet.init(withData: ["source": [-122.448586,   37.793414], "destination": [-123.408586, 38.793414]], withName: "Fish", withWeight: "100", withPrice: "30"),Packet.init(withData: ["source": [-122.408586, 37.795914], "destination": [-122.408586,   37.781414]], withName: "Honey", withWeight: "10", withPrice: "100"), Packet.init(withData: ["source": [-122.408586, 35.793414], "destination": [-123.408586, 37.793414]], withName: "Pen", withWeight: "20", withPrice: "20"),    Packet.init(withData: ["source": [-121.408586, 35.793414], "destination": [-123.408586, 34.793414]], withName: "Paper", withWeight: "10", withPrice: "60")  ]
    
    
    
    lazy var showPackagesAlert: UIAlertController = {
        let controller = UIAlertController(title: "", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
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
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    override func setupViews() {
        self.view.addSubview(mapView)
        self.mapView.addSubview(myPackages)
        
        setupMarkersAndLinesBetweenThem()
    }
    
    func setupMarkersAndLinesBetweenThem() {
        
        // Creating a marker for every item in the list and connects them
        for p in packageList{
            let sourcePosition = CLLocationCoordinate2D(latitude: p.source.latitude, longitude: p.source.longitude)
            let sourceMarker = GMSMarker(position: sourcePosition)
            sourceMarker.icon = UIImage(named: "transportablePackage")
            sourceMarker.title = "\(p.name) - Source"
            sourceMarker.map = mapView
            
            let destinationPosition = CLLocationCoordinate2D(latitude: p.destination.latitude, longitude: p.destination.longitude)
            let destionationMarker = GMSMarker(position: destinationPosition)
            destionationMarker.icon = UIImage(named: "destinationPackage")
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
    
    
    
    override func setupAnchors() {
        _ = mapView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = myPackages.anchor(nil, left: nil, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 24, rightConstant: 24, widthConstant: self.view.frame.width*2/5, heightConstant: self.view.frame.height/12)
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
        
        currentLocation.longitude = (locations.last?.coordinate.longitude)!
        currentLocation.latitude = (locations.last?.coordinate.latitude)!
        let camera = GMSCameraPosition.camera(withLatitude:  currentLocation.latitude, longitude:  currentLocation.longitude, zoom: 20)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MessengerPopupTableViewCell
        //Assigning values to custom cell
        cell.nameLabel.text = packageList[indexPath.item].name
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.1
        
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //adding left pull action
        let drop = UITableViewRowAction(style: .destructive, title: "Dropped") { (action, indexPath) in
            let droppedPackage = self.packageList[indexPath.row]
            self.confirmDrop(withPackage: droppedPackage)
        }
        drop.backgroundColor = UIColor(red: 186.0/255.0, green: 46.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        return [drop]
    }
    
    func confirmDrop(withPackage package: Packet) {
        print(package.name)
        print(findDistanceBetweenTwoLocations(package.destination, currentLocation))
        print("destionation: location: \(package.destination.longitude) - \(package.destination.latitude)")
        print("current location: \(currentLocation.longitude) - \(currentLocation.latitude)")
        print("---------------")
        
        if(findDistanceBetweenTwoLocations(package.destination, currentLocation) <= 0.05){
            print("Package dropped")
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
