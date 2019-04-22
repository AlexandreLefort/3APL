//
//  UIViewControllerMaps.swift
//  3APL_GBL
//
//  Created by Aiman Bahouala on 19/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation


class UIViewControllerMaps: UIViewController,CLLocationManagerDelegate {

    var timer = Timer()
    let locationManager = CLLocationManager()
    var latitude:Double?
    var longitude:Double?
    var camera:GMSCameraPosition?
    var mapView:GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.interval()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        self.camera = GMSCameraPosition.camera(withLatitude: 49.254641, longitude: 4.032429, zoom: 2.0)
        
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: self.camera!)
        self.view = self.mapView
        
        var connectionCheck : Connectivity = Connectivity()
        connectionCheck.checkConnectivity()
        // Creates a marker
        if connectionCheck.online{
            // Via API
            var data:Dictionary<String,Any> = ["action":"getPosition"]
            data["username"] = "admin"
            data["password"] = "admin"
            
            let apiManager = ApiManager(postMethod: data)
            apiManager.returnUserPosition(){ UserTableReturn in
                
                // ici votre code de traitement
                for data:User in UserTableReturn{
                    let marker = data.createMarker()
                    marker.map = self.mapView
                }
                
            }
        }else{
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("database.sqlite")
            print(fileURL)
            let sqlWrapper:MysqlWrapperGBL = MysqlWrapperGBL(fileURL: fileURL)
            let temp = sqlWrapper.selectAllUser()
            if (temp != nil) {
                for data:User in temp!{
                let marker = data.createMarker()
                marker.map = self.mapView
                }
        }
    }
}
    // Fonction qui lance le timer toute les 1 secondes
    func interval(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateSelfPosition), userInfo: nil, repeats: true)
        
    }
    
    // Tache qui est effectuée toute les secondes et affiche la position de la personne connecté
    @objc func updateSelfPosition(){
        
        self.locationManager.startUpdatingLocation()
       
       var connectionChecker:Connectivity = Connectivity()
       connectionChecker.checkConnectivity()
        if(connectionChecker.online){

            // Via API
            var data:Dictionary<String,Any> = ["action":"update"]
            data["username"] = "admin"
            data["password"] = "admin"
            data["latitude"] = "\(self.latitude)"
            data["longitude"] = "\(self.longitude)"
            
            let apiManager = ApiManager(postMethod: data)
            
            if(latitude != nil && longitude != nil){
                var userOffline:User = User(lastname: "Admin", firstName: "Admin", latitude: self.latitude, longitude: self.longitude, famille: nil, id: nil)
                var marker = userOffline.createMarker()
                marker.map = self.mapView
            }
            
        }else{
            
            if(latitude != nil && longitude != nil){
                var userOffline:User = User(lastname: "Admin", firstName: "Admin", latitude: self.latitude, longitude: self.longitude, famille: nil, id: nil)
                var marker = userOffline.createMarker()
                marker.map = self.mapView
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
    
    }
    
}
