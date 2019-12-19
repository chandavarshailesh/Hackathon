//
//  PlacesAPIClient.swift
//  Hackathon
//
//  Created by Pavan Gopal on 19/12/19.
//  Copyright © 2019 Shailesh. All rights reserved.
//

import Foundation

final class PlacesApiClient {
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    private let GOOGLEAPIKEY = "AIzaSyDA3yNIfWCFeT7MAyJXA11b7IufbUgxW1I"
    
    private let dispatchGroup = DispatchGroup()
    
    var geoNotificationArray: [GeoNotification] = []
        
    func fetchGeoCordinateList(for latitude: Double, longitude: Double, radius: Double, completion: @escaping (Result<[GeoNotification], Error>) -> Void ) {
        
        [LocationType.Apparel, LocationType.Competition, LocationType.Lenskart].forEach { (locationType) in
            
            getPlace(parameters: [
                "query" : locationType.queryString,
                "location" : "\(latitude),\(longitude)",
                "radius": radius,
                "key" : GOOGLEAPIKEY], locationType: locationType) { [weak self] in
                    
                    self?.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            print("finished fetching all locations")
            completion(.success(self.geoNotificationArray))
        }
    }
    
    private func getPlace(parameters: [String : Any], locationType: LocationType, completion: @escaping () -> Void) {
        
        guard let url = URL(string: baseURLString),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true), !parameters.isEmpty else {  return }
        
        urlComponents.queryItems = [URLQueryItem]()
        urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0, value: "\($1)") })
        
        dispatchGroup.enter()
        
        URLSession.shared.dataTask(with: urlComponents.url!) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            guard let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
                as? [String: Any], let results = responseData["results"] as? [NSDictionary]else {
                    print("error trying to convert data to JSON")
                    return
            }
            
            self.geoNotificationArray.append(contentsOf: results[0..<5].map({GeoNotification(json: $0, locationType: locationType)}))
            
            completion()
            
        }.resume()
    }
}
