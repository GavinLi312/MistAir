//
//  LineChartFormatter.swift
//  MistAir
//
//  Created by Michelle Zhu on 5/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

//https://medium.com/@felicity.johnson.mail/lets-make-some-charts-ios-charts-5b8e42c20bc9

import UIKit
import Charts

class LineChartFormatter: NSObject,  IAxisValueFormatter{
    
    var dateList = [String]()
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateList[Int(value)]
    }
    
    func setValue(values: [String]) {
        self.dateList = values
    }
}

