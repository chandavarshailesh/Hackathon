
//
//  GeoNotificationManager.swift
//  Hackathon
//
//  Created by Shailesh on 18/12/19.
//  Copyright © 2019 Shailesh. All rights reserved.
//

import Foundation
import CoreLocation

class GeoNotificationManager {
    
    static let locationManager = CLLocationManager()
    
    static func startMonitoring(pointOfObservation: GeoNotification) {
        let region = regionForGeoNotification(geoNotification: pointOfObservation)
        locationManager.startMonitoring(for: region)
    }
    
    static func regionForGeoNotification(geoNotification: GeoNotification) -> CLCircularRegion {
      let offerRegion = CLCircularRegion(center: geoNotification.coordinate, radius: geoNotification.radius, identifier: geoNotification.identifier)
      offerRegion.notifyOnExit = false
      return offerRegion
    }
    
    
    static func stopMonitoring(pointOfObservation: GeoNotification) {
        let region = regionForGeoNotification(geoNotification: pointOfObservation)
        locationManager.stopMonitoring(for: region)
    }
    
    static func showGeoNotification(pointOfObservation: GeoNotification) {
        pointOfObservation.showNotification()
    }
    
    
}
