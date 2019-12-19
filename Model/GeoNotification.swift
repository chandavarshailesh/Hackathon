//
//  GeoNotification.swift
//  Hackathon
//
//  Created by Shailesh on 18/12/19.
//  Copyright © 2019 Shailesh. All rights reserved.
//

import Foundation
import CoreLocation
import NotificationCenter

struct GeoNotification: Codable {
    
    var latitude: Double = 0
    var longitude: Double = 0
    var radius : Double = 0
    var identifier = ""
    var title = ""
    var message = ""
    var locationType: LocationType?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init() {
        
    }
    
    init(json: NSDictionary, locationType: LocationType) {
        
        latitude = json.value(forKeyPath: "geometry.location.lat") as? Double ?? 0
        longitude = json.value(forKeyPath: "geometry.location.lng") as? Double ?? 0
        title = json.value(forKeyPath: "name") as? String ?? ""
        self.locationType = locationType
    }
    
    
     func showNotification() {
        let content = UNMutableNotificationContent()
        content.title = title
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            guard error == nil else { return }
            print("Scheduling notification with id: \(self.identifier)")
        }
    }
}

enum LocationType: String, Codable {
    case Competition
    case Lenskart
    case Apparel
    
    var queryString: String {
        switch self {
        case .Competition:
            return "titan eye plus"
        case .Lenskart:
            return "lenskart"
        default:
            return "Manyavar"
        }
    }
}


