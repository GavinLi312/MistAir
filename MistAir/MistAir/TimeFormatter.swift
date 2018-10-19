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
    
}
