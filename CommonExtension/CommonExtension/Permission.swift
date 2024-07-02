import Foundation
import CoreLocation
import UserNotifications
import UIKit

public class Permission {
    
    public static func isLocationAllowed() -> Bool {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return true
        } else {
            return false
        }
    }
    
    public static func isNotificationAllowed(onCompleted: @escaping (_ userAllowed: Bool)-> Void ) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined: requestNotification(onCompleted: onCompleted)
            case .denied: onCompleted(false)
            case .authorized: onCompleted(true)
            case .provisional: onCompleted(true)
            default: onCompleted(true)
            }
        })
    }
    
    public static func requestNotification(onCompleted: @escaping (_ userAllowed: Bool)-> Void ) {
        let center  = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error != nil { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                onCompleted(granted)
            }
                
        }
    }
    
    public static func getNotificationPermissionStatus(onCompleted: @escaping (_ status: UNAuthorizationStatus)-> Void ) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            DispatchQueue.main.async {
                onCompleted(settings.authorizationStatus)
            }
        })
    }
}

extension UNAuthorizationStatus {
    public var isNotDetermined: Bool {
        self == .notDetermined
    }
}
