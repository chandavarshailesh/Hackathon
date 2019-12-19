//
//  NotificationPermissionViewController.swift
//  Hackathon
//
//  Created by Shailesh on 18/12/19.
//  Copyright © 2019 Shailesh. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


class NotificationPerMissionViewController: BaseViewController {
    
    override func viewDidLoad() {
        checkNotificationSeetingAndRequestAccess()
    }
    
    
    func checkNotificationSeetingAndRequestAccess() {
        notificationServiceStatus {[weak self] (accessAvailable) in
            guard let self = self else {return}
            
            if accessAvailable {
                self.pushLocationPermissionScreen()
            } else {
                self.requestNotificationPermission()
            }
            
        }
    }
    
    
    func notificationServiceStatus( completionHandler: @escaping (Bool) -> ()) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            completionHandler(settings.authorizationStatus == .authorized)
        })
    }
    
    
    
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { [weak self] (granted, error) in
            guard let self = self else {return}
            if let error = error {
                self.showAlertWithTitle(title: "Something went wrong!!!!", message: error.localizedDescription)
            } else {
                self.pushLocationPermissionScreen()
            }
        }
    }
    
    private func pushLocationPermissionScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.performSegue(withIdentifier: "locationScreen", sender: nil)
        }
    }
    
    
    
}
