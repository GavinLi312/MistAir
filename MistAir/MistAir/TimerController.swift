//
//  TimerController.swift
//  MistAir
//
//  Created by Salamender Li on 17/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit
protocol ReadTimeDelegate {
    func changeLabel(startMinute:Int,Duration:Int)
}


struct TimerFirebase {
    var startTime:NSDate = NSDate()
    var duration : TimeInterval = 0.0
    var timerStatus = false
    
}

class TimerController: UIViewController,ReadTimeDelegate {


//    let shapeLayer = CAShapeLayer()
//    var pulsatingLayer: CAShapeLayer!
    var currentCircleSlider: CircleSlider!
    
    var startAndEndTime : [NSDate] = []
    
    var customedTabBarController : BaseTabBarController?
    
    let startLabel : UILabel = {
        let label = UILabel()
        label.text = "StartTime"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
//                label.layer.borderColor = UIColor.black.cgColor
//                label.layer.borderWidth = 2
        return label
    }()
    
    let startTime : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2

        return label
    }()
    
    let endLabel : UILabel = {
        let label = UILabel()
        label.text = "EndTime"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2
        return label
    }()
    
    let endTime : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2

        return label
    }()
    
    let setButton : UIButton = {
        let button = UIButton()
        button.setTitle("SET", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.setImage(UIImage(named: "homepage_empty-20"), for: .normal)
        button.backgroundColor = UIColor.buttonPurple
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBackGroundView()
        initializeCircleView()
        initializeStartTimeLabel()
        initializeEndTimeLabel()
        initializeButton()
        self.customedTabBarController = self.tabBarController as! BaseTabBarController
        print(self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.duration)
        print(self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.startTime)
        print(self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.timerStatus)
        
    }
    
    
    ///backGroundPageview
    func initializeBackGroundView(){
        var backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        //        backgroundView.image = UIImage(named: "Triangle-Kids-Books" )
        self.view.backgroundColor = UIColor.darkPurple
        self.view.addSubview(backgroundView)
    }
    
    


    func initializeCircleView(){
        if currentCircleSlider != nil { currentCircleSlider.removeFromSuperview() }
        
        let circleSlider = CircleSlider(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.width))
        
        circleSlider.makeSlider()
        circleSlider.start_point = CGPoint(x: circleSlider.circle_center.x, y: circleSlider.circle_center.y - circleSlider.circle_diameter/2)
        circleSlider.end_point = CGPoint(x: circleSlider.circle_center.x + circleSlider.circle_diameter/2, y: circleSlider.circle_center.y )
        circleSlider.updateTouchTrail()
        circleSlider.changeLabelProtocol = self
        currentCircleSlider = circleSlider
        currentCircleSlider.layer.shadowOffset = CGSize(width: 0, height: 5)
        currentCircleSlider.layer.shadowRadius = 5
        currentCircleSlider.layer.shadowOpacity = 0.3
        currentCircleSlider.layer.shadowColor = UIColor.lightGray.cgColor
        self.view.addSubview(circleSlider)
        
    }

    func initializeStartTimeLabel() {
        
        view.addSubview(startTime)
        view.addSubview(startLabel)
        startTime.translatesAutoresizingMaskIntoConstraints = false
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async{
//            self.startTime.text = "\((self.currentCircleSlider.start_point)!)"
       
            self.startTime.widthAnchor.constraint(equalToConstant: 150).isActive = true
            self.startTime.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.startTime.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
            self.startTime.bottomAnchor.constraint(equalTo: self.currentCircleSlider.topAnchor, constant: 10).isActive = true
            self.startTime.topAnchor.constraint(equalTo: self.startLabel.bottomAnchor, constant: 5).isActive = true
            
            self.startLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
            self.startLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            self.startLabel.bottomAnchor.constraint(equalTo: self.startTime.topAnchor, constant: 10).isActive = true
            self.startLabel.leftAnchor.constraint(equalTo: self.startTime.leftAnchor, constant: 0).isActive = true
            self.startLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
            
            
        self.view.bringSubview(toFront: self.startTime)
            self.view.bringSubview(toFront: self.startLabel)
             }
    }
    
    func initializeEndTimeLabel() {
        view.addSubview(endTime)
        view.addSubview(endLabel)
        endTime.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async{
//            self.endTime.text = "\((self.currentCircleSlider.end_point)!)"
            
            self.endTime.widthAnchor.constraint(equalToConstant: 150).isActive = true
            self.endTime.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.endTime.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
            self.endTime.bottomAnchor.constraint(equalTo: self.startTime.bottomAnchor, constant: 0).isActive = true
            self.endTime.topAnchor.constraint(equalTo: self.startTime.topAnchor, constant: 0).isActive = true
            
            self.endLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
            self.endLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            self.endLabel.bottomAnchor.constraint(equalTo: self.startLabel.bottomAnchor, constant: 0).isActive = true
            self.endLabel.rightAnchor.constraint(equalTo: self.endTime.rightAnchor, constant: 0).isActive = true
            self.endLabel.topAnchor.constraint(equalTo: self.startLabel.topAnchor, constant: 0).isActive = true
        }

        view.bringSubview(toFront: endTime)
        view.bringSubview(toFront: endLabel)
        self.currentCircleSlider.updateTouchTrail()
    }
    
    func initializeButton() {
        view.addSubview(self.setButton)
        setButton.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async{
            
            self.setButton.widthAnchor.constraint(equalToConstant: self.currentCircleSlider!.circle_diameter).isActive = true
            self.setButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.setButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.setButton.topAnchor.constraint(equalTo: self.currentCircleSlider.bottomAnchor, constant: 0).isActive = true
        }
        self.setButton.addTarget(self, action: #selector(setButtonIsClicked(_:)), for: .touchUpInside)
    }
    
    func changeLabel(startMinute:Int,Duration:Int) {
        DispatchQueue.main.async{
            self.startAndEndTime = self.getTimeByMinute(minute: startMinute, duration: Duration)
            self.startTime.text = "\(NSDate.convertNSdateToString(date: self.startAndEndTime[0]))"
            self.endTime.text = "\((NSDate.convertNSdateToString(date: self.startAndEndTime[1])))"
        }
    }
    
    func getTimeByMinute(minute:Int,duration:Int) -> [NSDate] {
        let startDate = NSDate(timeIntervalSinceNow: TimeInterval(minute * 60))
        let endDate = startDate.addingTimeInterval(TimeInterval(duration*60))
        return [startDate,endDate]
    }
    
    
    @objc func setButtonIsClicked(_ sender: UIButton) {
        var newTimer = TimerFirebase()
        newTimer.startTime = self.startAndEndTime[0]
        let startTimeDiffer = startAndEndTime[0].timeIntervalSinceNow
        let endTimeDiffer = startAndEndTime[1].timeIntervalSinceNow
        newTimer.duration = endTimeDiffer - startTimeDiffer
        newTimer.timerStatus = true
        customedTabBarController?.humidiferFirebase.setTimer(newTimer: newTimer)
    }
    
    func getEndTime(){
        
    }
    
    
}
