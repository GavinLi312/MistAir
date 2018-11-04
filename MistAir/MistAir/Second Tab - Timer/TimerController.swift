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

protocol TimerControllerFirebase {
    
    func waterSourceChange(waterStatus:Bool)
    
    func timerStatusCanceled()
}


class TimerController: UIViewController,ReadTimeDelegate,TimerControllerFirebase {


//    let shapeLayer = CAShapeLayer()
//    var pulsatingLayer: CAShapeLayer!
    var currentCircleSlider: CircleSlider!
    
    var startAndEndTime : [NSDate] = []
    
    var customedTabBarController : BaseTabBarController? 
    
    var startandEndAngle : [CGFloat] = []
    
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
        button.setTitle(" SET", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.setImage(UIImage(named: "timer-20"), for: .normal)
        button.backgroundColor = UIColor.buttonPurple
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2
        
        return label
    }()

    var timerStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2
        
        return label
    }()
    
    var timer: Timer = Timer()
    
    var timerControllerTimerStatus : HumidifierSwitchStatus = .off{
        didSet{
            switch timerControllerTimerStatus {
            case .on:
                print(timerControllerTimerStatus)
                self.setButton.setTitle(" CANCEL", for: .normal)
                self.currentCircleSlider.isUserInteractionEnabled = false
                self.startTiming()
                self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.startTiming), userInfo: nil, repeats: true)
                
                //self.currentCircleSlider.
//                self.humidifierStatusLabel.text = "On"
//                let buttonImage = UIImage(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: .down)
//                self.switchButton.setImage(buttonImage, for: .normal)
//                self.switchButton.setTitle(" TURN OFF", for: .normal)
//                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
            case .off:
                print(timerControllerTimerStatus)
                self.setButton.setTitle(" SET", for: .normal)
                self.currentCircleSlider.isUserInteractionEnabled = true
                self.timerStatusLabel.text = "Closed"
                if timer.isValid == true{
                    timer.invalidate()

                    self.timeLabel.text = "00:00"
                }
//                self.humidifierStatusLabel.text = "Off"
//                let buttonImage = UIImage(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: .up)
//                self.switchButton.setImage(buttonImage, for: .normal)
//                self.switchButton.setTitle(" TURN ON", for: .normal)
//                self.runningTimeLabel.text = "00:00:00"
//                if self.timer.isValid == true{
//                    self.timer.invalidate()
//                }
            case .noWater:
                print(timerControllerTimerStatus)
//                self.timerStatusLabel.text = "N"
                self.setButton.setTitle(" No Water", for: .normal)
                
                self.currentCircleSlider.isUserInteractionEnabled = false
//                self.humidifierStatusLabel.text = "No Water"
//                print("i have no water")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customedTabBarController = self.tabBarController as? BaseTabBarController
        initializeBackGroundView()
        initializeCircleView()
        initializeStartTimeLabel()
        initializeEndTimeLabel()
        initializeButton()
        initializeTimeLabel()
        initializeTimeStatus()
        if self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.waterSufficient == true{
        
            if self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.timerStatus == true{
                self.timerControllerTimerStatus = .on
            }else if customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.timerStatus == false{
                self.timerControllerTimerStatus = .off
            }
        }else{
            self.timerControllerTimerStatus = .noWater
        }


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
        
        self.customedTabBarController?.humidiferFirebase.timerPageProtocol = self
        print(self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.duration)
        print(self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.startTime)
                print(self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.timerStatus)

        self.startAndEndTime = self.getStartTimeAndEndTime(startTime: ((self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.startTime)!), duration: (self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.duration)!)
        
        
        self.startandEndAngle = [circleSlider.getStartAngleFromMinute(minute: NSDate.caulculateTimeDifference(date1: NSDate(), date2:self.startAndEndTime[0])),circleSlider.getEndAngleFromMinute(minute: NSDate.caulculateTimeDifference(date1: self.startAndEndTime[0], date2: self.startAndEndTime[1]))]
        circleSlider.start_point = circleSlider.pointOnCircle(forRad: self.startandEndAngle[0] - CGFloat.pi/2, withRadius: circleSlider.circle_diameter/2)
        circleSlider.end_point = circleSlider.pointOnCircle(forRad: self.startandEndAngle[1] - CGFloat.pi/2, withRadius: circleSlider.circle_diameter/2)

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
    
    func initializeTimeLabel(){
        view.addSubview(self.timeLabel)
        self.timeLabel.frame = CGRect(x: self.currentCircleSlider.circle_center.x, y: self.currentCircleSlider.circle_center.y, width: 180, height: 60)
        self.timeLabel.center.x = self.currentCircleSlider.center.x
        self.timeLabel.center.y = self.currentCircleSlider.center.y
    }
    
    func initializeTimeStatus(){
        view.addSubview(self.timerStatusLabel)
        timerStatusLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.timerStatusLabel.frame = CGRect(x: self.currentCircleSlider.circle_center.x, y: self.currentCircleSlider.circle_center.y, width: 60, height: 60)
        self.timerStatusLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.timerStatusLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.timerStatusLabel.bottomAnchor.constraint(equalTo: self.timeLabel.topAnchor, constant: 0).isActive = true
        self.timerStatusLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
    
    func changeLabel(startMinute:Int,Duration:Int) {
        DispatchQueue.main.async{
            self.startAndEndTime = self.getTimeByMinute(minute: startMinute, duration: Duration)
//            print(self.startAndEndTime)
            self.startTime.text = "\(NSDate.convertNSdateToString(date: self.startAndEndTime[0]))"
            self.endTime.text = "\((NSDate.convertNSdateToString(date: self.startAndEndTime[1])))"
        }
    }
    
    func getTimeByMinute(minute:Int,duration:Int) -> [NSDate] {
        let startDate = NSDate(timeIntervalSinceNow: TimeInterval(minute * 60))
        let endDate = startDate.addingTimeInterval(TimeInterval(duration*60))
        print(NSDate.convertDateToFullString(date: startDate))
        print(NSDate.convertDateToFullString(date: endDate))
        return [startDate,endDate]
    }
    
    
    @objc func setButtonIsClicked(_ sender: Any) {
        print(self.timerControllerTimerStatus)
        if self.timerControllerTimerStatus == .noWater{
            self.noWaterWarning()
        }else{
            if self.timerControllerTimerStatus == .off{
                let homeController = customedTabBarController?.viewControllers![0].childViewControllers[0] as! HomePageController
                if customedTabBarController?.humidiferFirebase.myHumidifierStatus.status == true{
                    homeController.switchButtonWasPressed(self)
                }
                var newTimer = TimerFirebase()
                newTimer.startTime = self.startAndEndTime[0]
                let startTimeDiffer = startAndEndTime[0].timeIntervalSinceNow
                let endTimeDiffer = startAndEndTime[1].timeIntervalSinceNow
                
                newTimer.duration = endTimeDiffer - startTimeDiffer
                newTimer.timerStatus = true
                customedTabBarController?.humidiferFirebase.setTimer(newTimer: newTimer)
                self.timerControllerTimerStatus = .on
            }else if self.timerControllerTimerStatus == .on{
                customedTabBarController?.humidiferFirebase.cancelTimer()
                self.timerControllerTimerStatus = .off
            }
        }
    }
    
    
    func getStartTimeAndEndTime(startTime:NSDate,duration:TimeInterval) -> [NSDate]{
        var endDate = startTime.addingTimeInterval(duration)
        var startDate = startTime
        if startTime.compare(NSDate() as Date) == ComparisonResult.orderedAscending{
            startDate = NSDate()
        }
        
        if endDate.compare(NSDate() as Date) == ComparisonResult.orderedAscending{
            endDate = NSDate()
        }
        return [startDate,endDate]
    }
    
    func waterSourceChange(waterStatus: Bool) {
//        print("i am running")
        if waterStatus == true{
            self.timerControllerTimerStatus = .off
            self.setButton.setTitle("Ready", for: .normal)
        }else{
            if self.timerControllerTimerStatus == .on{
                self.setButtonIsClicked(self)
            }
            self.timerControllerTimerStatus = .noWater
            print(self.timerControllerTimerStatus)
            noWaterWarning()
        }

    }
    
    func timerStatusCanceled() {
        
        if self.timerControllerTimerStatus != .off{
            if self.timerControllerTimerStatus != .noWater{
            self.timerControllerTimerStatus = .off
            }
        }
    }
    
    func noWaterWarning(){
        let alertController = AlertMessage.displayErrorMessage(title: "Water Source", message: "The Water Source of the humidifier is not sufficient, Please Check.")
        self.present(alertController, animated: true, completion: nil)
        AlertMessage.pushNotification(title: "Water Source", body: "The Water Source of the humidifier is not sufficient, Please Check.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func startTiming(){
        
        let reference = NSDate()
        
        if self.startAndEndTime[0].compare(reference as Date) == ComparisonResult.orderedAscending{
            if self.startAndEndTime[1].compare(reference as Date) == ComparisonResult.orderedDescending{
                self.timerStatusLabel.text = "Running"
                self.timeLabel.text = NSDate.stringFromTimeIntervalAsHourAndMinutes(interval: self.startAndEndTime[1].timeIntervalSinceNow)
            }else{
                print("should not happen")
            }
        }else{
            //self.timeLabel =
            self.timerStatusLabel.text = "Start"
            self.timeLabel.text = NSDate.stringFromTimeIntervalAsHourAndMinutes(interval: self.startAndEndTime[0].timeIntervalSinceNow)
        }
    }
}
