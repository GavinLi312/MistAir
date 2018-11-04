//
//  AlertMessage.swift
//  MistAir
//
//  Created by Salamender Li on 2/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class AlertMessage {
    
    
    static func displayErrorMessage(title:String, message: String) -> UIAlertController{
        let alertview = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        return alertview
    }
    
    static func pushNotification(title: String, body: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "humidifierState", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
