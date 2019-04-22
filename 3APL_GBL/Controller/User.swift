//
//  User.swift
//  3APL_GBL
//
//  Created by Aiman Bahouala on 17/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import Foundation
import GoogleMaps

class User {
    
    var id: Int32?
    var lasName: String
    var firstName: String
    var latitude: Double?
    var longitude: Double?
    var famille: String?
    
    init( lastname: String, firstName: String, latitude: Double?, longitude: Double?, famille: String?, id: Int32?){
        self.lasName = lastname;
        self.firstName = firstName;
        self.latitude = latitude;
        self.longitude = longitude;
        self.famille = famille;
        self.id = id;
    }
    
    func getlastName() -> String! {
        return self.lasName
    }
    
    func getFirstName() -> String! {
        return self.firstName
    }
    
    func getPosition() -> [Double] {
        
        if self.latitude != nil && self.longitude != nil{
            return [self.latitude!,self.longitude!]
        }else{
            return [0,0]
        }
        
     
    }
    
    func createMarker() -> GMSMarker{
        let marker = GMSMarker()
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.position = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        marker.title = self.getFirstName()
        marker.snippet = self.getlastName()
        //print(marker)
        return marker
    }
}
