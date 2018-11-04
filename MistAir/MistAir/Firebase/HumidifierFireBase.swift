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
    var timer = TimerFirebase()
    var waterSufficient = false
}

let group = DispatchGroup()

class HumidifierFirebase {
    
    var myHumidifierStatus = humidifierStatus()
    
    var oldHumidifierStarus : humidifierStatus?
    
    var humidifierKey  = "-LQHaJMvoyvWyBicOSjr"
    
    var databaseRef:DatabaseReference?
    
    var humidifierRef: DatabaseReference?
    
    var homePageProtocol : HomePageFirebase?
    
    var timerPageProtocol : TimerControllerFirebase?
    
    init() {
        databaseRef = Database.database().reference()
        humidifierRef = databaseRef?.child("humidifier")
        print(UserDefaults.standard.string(forKey: "Humidifier ID")!)
        print(humidifierKey)
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
                    var timerArray = humidifierfirebase!["timer"] as! [String:Any]
                    self.myHumidifierStatus.timer.startTime = NSDate(timeIntervalSince1970: (timerArray["start Time"] as! Double))
                    self.myHumidifierStatus.timer.duration = timerArray["duration"] as! TimeInterval
                    self.myHumidifierStatus.timer.timerStatus = timerArray["status"] as! Bool
                    
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
            var endtime = self.myHumidifierStatus.timer.startTime.addingTimeInterval(self.myHumidifierStatus.timer.duration)
            
            if endtime.compare(NSDate() as Date) == ComparisonResult.orderedAscending{
                var newTimer = TimerFirebase()
                newTimer.startTime = NSDate().addingTimeInterval(60)
                
                newTimer.duration = 1800
                newTimer.timerStatus = false
                self.setTimer(newTimer: newTimer)
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
                
                if self.timerPageProtocol != nil{
                    if self.myHumidifierStatus.timer.timerStatus != self.oldHumidifierStarus?.timer.timerStatus{
                        if self.myHumidifierStatus.timer.timerStatus == false{
                            self.timerPageProtocol?.timerStatusCanceled()
                        }
                    }
                    
                    if self.myHumidifierStatus.waterSufficient != self.oldHumidifierStarus!.waterSufficient{
                        self.timerPageProtocol?.waterSourceChange(waterStatus:self.myHumidifierStatus.waterSufficient)
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
    
    func setTimer(newTimer:TimerFirebase) {

        let data = [
            "start Time": newTimer.startTime.timeIntervalSince1970,
            "duration": newTimer.duration,
            "status":newTimer.timerStatus
            ] as [String : Any]
        
        humidifierRef?.child(self.humidifierKey).child("timer").setValue(data)
    }
    
    func cancelTimer(){
        humidifierRef?.child(self.humidifierKey).child("timer").child("status").setValue(false)
    }
    
}
