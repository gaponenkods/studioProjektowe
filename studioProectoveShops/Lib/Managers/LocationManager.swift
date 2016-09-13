//
//  LocationManager.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 10.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    let locationManager = CLLocationManager()
    var previous = NSDecimalNumber.one()
    var current = NSDecimalNumber.one()
    var position: UInt = 1
    var updateTimer: NSTimer?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var currentLocation: CLLocation?
    var secondDelegate: CLLocationManagerDelegate?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        triggerLocationServices()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.allowsBackgroundLocationUpdates = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    func triggerLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            if self.locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) {
                locationManager.requestWhenInUseAuthorization()
            } else {
                
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var str: String
        
        switch status {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
            str = "NotDetermined"
            
        case .AuthorizedWhenInUse:
            startUpdatingLocation()
            str = "AuthorizedWhenInUse"
            locationManagerAlert()
            
        case .AuthorizedAlways:
            startUpdatingLocation()
            str = "AuthorizedAlways"
            
        case .Restricted, .Denied:
            locationManagerAlert()
            str = "Restricted"
        }
        
        print("locationManager auth status changed, \(str)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        if let secondDelegate = secondDelegate {
            secondDelegate.locationManager!(manager, didUpdateLocations: locations)
        }
    }
    
    func locationManagerAlert() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to be notified server about missing sessions, please open this app's settings and set location access to 'Always'.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        router().displayAlertController(alertController)
    }
    

    
}
