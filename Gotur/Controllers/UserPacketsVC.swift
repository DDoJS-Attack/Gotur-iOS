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

class UserPacketsVC: BaseVC, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var packets = [Packet]()
    var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_add_circle_48pt"), for: .normal)
        button.addTarget(self, action: #selector(goToAddPacketVC), for: .touchUpInside)
        return button
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
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        fillDB()
        parsePackets()
        
        self.view.addSubview(addButton)
    }
    
    override func setupAnchors() {
        _ = addButton.anchor(nil, left: nil, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 70, rightConstant: 8, widthConstant: 60, heightConstant: 60)
    }
    
    override func fetchData() {
        
    }
    
    func fillDB() {
        let lng = "\(Double((locationManager.location?.coordinate.longitude)!))"
        let lat = "\(Double((locationManager.location?.coordinate.latitude)!))"
        let lng2 = "\(Double((locationManager.location?.coordinate.longitude)!))"
        let lat2 = "\((Double((locationManager.location?.coordinate.latitude)!)) - 0.01)"

//        let item1 = Packet(data: ["source": [lng2, lat2], "destination": [lng, lat]])
//        let item2 = Packet(data: ["source": ["150", "-32"], "destination": ["-30", "180"]])
//        packets.append(item1)
//        packets.append(item2)
    }
    
    func parsePackets() {
        for packet in packets {
            let packetMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(packet.source.latitude)!, longitude: Double(packet.source.longitude)!))
            packetMarker.title = "Sydney"
            packetMarker.snippet = "Ağırlık: 10 kg\nFiyat: 12 tl\nKargoyu götürmek için tıklayınız."
            packetMarker.icon = UIImage(named: "ic_feedback_white")
            packetMarker.map = mapView
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // Display alert
        let alert = UIAlertController(title: "", message: doYouWantToDeliverThisPacket, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: yesString, style: UIAlertActionStyle.default, handler:{action in self.takePacket()}))
        alert.addAction(UIAlertAction(title: noString, style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func takePacket() {
        // Change marker
        // Push appropriate data
        // Draw path from courier to packet to destination
        drawPath()
        let addPacketVC = AddPacketVC()
        present(addPacketVC, animated: true, completion: nil)
    }
    
    func goToAddPacketVC() {
        let addPacketVC = AddPacketVC()
        present(addPacketVC, animated: true, completion: nil)
    }
    
    func drawPath()
    {
        let origin = "\(Double(packets[0].source.latitude)),\(Double(packets[0].source.longitude))"
        let destination = "\(Double(packets[0].destination.latitude)),\(Double(packets[0].destination.longitude))"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&sensor=false"
        
        Alamofire.request(url).responseJSON { response in
            print(response.result)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                print(json)
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.map = self.mapView
                }
            } catch {
                // Error
                print("Error")
            }
        }
    }
}
