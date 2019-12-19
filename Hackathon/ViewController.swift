//
//  ViewController.swift
//  Hackathon
//
//  Created by Shailesh on 17/12/19.
//  Copyright © 2019 Shailesh. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: BaseViewController {

    private let locationManager = CLLocationManager()
    let placesApiClient = PlacesApiClient()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        
    }
    
    
    private func configureLocationManager() {
        requestLocationPermission()
    }
    
    
    private func requestLocationPermission() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                showNeedsLocationPermissionAlert()
                
            case .restricted:
                showAlertWithTitle(title: "Location Services are Restricted.", message: "It seems currently there is restriction on your location access.")
                
            case .authorizedWhenInUse:
                requestAlwaysPermission()
                
            case .authorizedAlways:
                loadPointOfObersavtions()
                
            case .notDetermined:
                requestAlwaysPermission()
                
            @unknown default:
                break
            }
        } else {
            showAlertWithTitle(title: "Location Services are Disabled", message: "Location Services are disabled for all apps please enable it in Settings > Privacy > Location Services.")
        }
        
    }
    
    private func requestAlwaysPermission() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    private func showNeedsLocationPermissionAlert() {
        showAlertWithTitle(title: "Lenskart needs location access.", message: "In order to use current location, please provide location access in the Settings app under Privacy -> Location Services.")
        
    }
    
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            requestAlwaysPermission()
        } else if status == .authorizedAlways {
            loadPointOfObersavtions()
        }
    }
    
    
    private func loadPointOfObersavtions() {
     
        //TODO: load all Point of obersvation and start geofence.
        placesApiClient.fetchGeoCordinateList(for: 12.98, longitude: 77.60, radius: 500) { (result) in
            switch result {
            case .success(let geoNotificationArray):
                print(geoNotificationArray)
                break
            case .failure(let error):
                break
            }
        }
        
//        let geoNotification = GeoNotification(latitude: 12.98, longitude: 77.60, radius: 200, identifier: "testFence", title: "This is a test fence", message: "This a message body")
//
//        GeoNotificationManager.startMonitoring(pointOfObservation: geoNotification)
        
        
        
    }
    
    
    
}




