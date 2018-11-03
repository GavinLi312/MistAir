//
//  HumidifierFireBase.swift
//  MistAir
//
//  Created by Salamender Li on 2/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct humidifierStatus {
    var currentHumidity : String = ""
    
    var HLMode = false
    var humidityHigherLevel : String = ""
    var humidityLowerLevel : String = ""
    var PDMode = false
    var turnOnTime: NSDate = NSDate()
    var humidityHistory : [String:String] = [:]
    var roomVacancy = false
    var status = false
    var timer : [String: String] = [:]
    var waterSufficient = false
}

let group = DispatchGroup()

class HumidifierFirebase {
    
    var myHumidifierStatus = humidifierStatus()
    var oldHumidifierStarus : humidifierStatus?
    
    var humidifierKey = "-LQHaJMvoyvWyBicOSjr"
    
    var databaseRef:DatabaseReference?
    
    var humidifierRef: DatabaseReference?
    
    var homePageProtocol : HomePageFirebase?
    
    init() {
        databaseRef = Database.database().reference()
        humidifierRef = databaseRef?.child("humidifier")
        getData()
    }
    
    func getData(){
        if self.oldHumidifierStarus == nil{
            group.enter()
        }

        humidifierRef?.observe(.value, with: {(snapshot) in
            guard let value = snapshot.value as? [String:NSDictionary] else{
                return
            }
            
            for key in value.keys{
                if key == self.humidifierKey {
                    let humidifierfirebase = value[key]
                    self.myHumidifierStatus.currentHumidity = (humidifierfirebase!["Current humidity"] as? String)!
                    self.myHumidifierStatus.HLMode = humidifierfirebase?["HLMode"] as! Bool
                    self.myHumidifierStatus.humidityHigherLevel = humidifierfirebase!["Humidity Higher Level"] as! String
                    self.myHumidifierStatus.humidityLowerLevel = humidifierfirebase!["Humidity Lower Level"] as! String
                    self.myHumidifierStatus.PDMode = humidifierfirebase?["HLMode"] as! Bool
                    self.myHumidifierStatus.humidityHistory = humidifierfirebase!["humidity History"] as! [String:String]
                    self.myHumidifierStatus.turnOnTime = NSDate(timeIntervalSince1970: (humidifierfirebase!["Turn on time"] as! Double))

                    self.myHumidifierStatus.roomVacancy = humidifierfirebase!["room vacant"] as! Bool
                    self.myHumidifierStatus.status = humidifierfirebase!["status"] as! Bool
                    self.myHumidifierStatus.waterSufficient = humidifierfirebase!["water Sufficient"] as! Bool
                    print(self.myHumidifierStatus.turnOnTime)
                    print(NSDate.convertNSdateToString(date: self.myHumidifierStatus.turnOnTime))
                    print(self.myHumidifierStatus)
                    if self.oldHumidifierStarus == nil{
                        group.leave()
                    }
                }
            }
            if self.oldHumidifierStarus != nil{
                if self.homePageProtocol != nil{
                    if self.myHumidifierStatus.currentHumidity != self.oldHumidifierStarus!.currentHumidity{
                        self.homePageProtocol?.humidityChanged()
                    }
                    if self.myHumidifierStatus.waterSufficient != self.oldHumidifierStarus!.waterSufficient{
                        self.homePageProtocol?.waterSourceChange(waterStatus:self.myHumidifierStatus.waterSufficient)
                    }
                }
                
            }else{
                
            }
            self.oldHumidifierStarus = self.myHumidifierStatus
            
        })
    }
    
    func setTurnOnTime(time:NSDate){
        humidifierRef?.child(self.humidifierKey).child("Turn on time").setValue(time.timeIntervalSince1970)
    }
    
    func setStatus(status:Bool){
        humidifierRef?.child(self.humidifierKey).child("status").setValue(status)
    }
    
    func setHLMode(status:Bool){
        humidifierRef?.child(self.humidifierKey).child("HLMode").setValue(status)
    }
    
    func setPDMode(status:Bool){
        humidifierRef?.child(self.humidifierKey).child("PDMode").setValue(status)
    }
    func setHumidityHigherLevel(highLevel:String)  {
        humidifierRef?.child(self.humidifierKey).child("Humidity Higher Level").setValue(highLevel)
    }
    func setHumidityLowerLevel(lowLevel:String) {
        humidifierRef?.child(self.humidifierKey).child("Humidity Higher Level").setValue(lowLevel)
    }
    
}
