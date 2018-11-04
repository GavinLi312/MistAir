//
//  TimeFormatter.swift
//  MistAir
//
//  Created by Salamender Li on 18/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import Foundation

extension NSDate{
    
    static func convertNSdateToString(date:NSDate) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let string = dateFormatter.string(from:date as Date )
        return string
    }
    
    static func caulculateTimeDifference(date1:NSDate,date2:NSDate) -> Int{
        let timeInterval1 = date1.timeIntervalSince1970
        let timeInterval2 = date2.timeIntervalSince1970
        let diff = abs(Int(timeInterval2 - timeInterval1))
        let minutes = diff / 60
        return minutes
    }
    
    static func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}