//
//  LocationService.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService{
    var currentLocation: CLLocation!
    var locManager = CLLocationManager()
    
    public init(){
        locManager.requestWhenInUseAuthorization()
    }
    
    public func getLocation() -> (String, String){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() ==  .authorizedAlways{
                self.currentLocation = self.locManager.location
                return ("-34","34")
            }
        return ("","")
    }
}
