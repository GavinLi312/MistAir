//
//  HomePageController.swift
//  MistAir
//
//  Created by Salamender Li on 15/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit
import UserNotifications

protocol HomePageFirebase {
    func humidityChanged()
    func waterSourceChange(waterStatus:Bool)
}

enum HumidifierSwitchStatus : Int{
    case on
    case off
    case noWater
}


class HomePageController: UIViewController,HomePageFirebase {

    var customedTabBarController : BaseTabBarController?
    
    let shapeLayer = CAShapeLayer()
    
    var pulsatingLayer: CAShapeLayer!
    
    let humidityStandards = [0.25,0.5,0.75]
    
    let currentStatus = ["dry", "slightly dry","normal", "humid"]
    
    let activityIndicator = UIActivityIndicatorView()
    
    var timer: Timer = Timer()
    //set up
    let humidityLabel : UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 70)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2
        return label
    }()
    
    let currentHumidityLabel : UILabel = {
        let label = UILabel()
        label.text = "CURRENT HUMIDITY"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2
        return label
        
    }()
    
    let currentHumidityStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "Humidity Status"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2
        return label
    }()
    
    let humidifierStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "On or Off"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
//                label.layer.borderColor = UIColor.black.cgColor
//                label.layer.borderWidth = 2
        return label
    }()
    
    let runningTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 2
        return label
    }()
    
    let image = UIImage(named: "power-button-2-20")
    
    let switchButton : UIButton = {
        let button = UIButton()
        button.setTitle(" TURN ON",for:.normal)
        button.setTitleColor(UIColor.white,for:.normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
//        let image = UIImage(named: "power-button-2-20")?.cgImage
//
//        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor.buttonPurple
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        return button
        
    }()
    
    var buttonStatus:HumidifierSwitchStatus = HumidifierSwitchStatus.off{
        didSet{
            switch buttonStatus {
            case .on:
                self.humidifierStatusLabel.text = "On"
                let buttonImage = UIImage(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: .down)
                self.switchButton.setImage(buttonImage, for: .normal)
                self.switchButton.setTitle(" TURN OFF", for: .normal)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
            case .off:
                self.humidifierStatusLabel.text = "Off"
                let buttonImage = UIImage(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: .up)
                self.switchButton.setImage(buttonImage, for: .normal)
                self.switchButton.setTitle(" TURN ON", for: .normal)
                self.runningTimeLabel.text = "00:00:00"
                if self.timer.isValid == true{
                    self.timer.invalidate()
                }
            case .noWater:
                self.humidifierStatusLabel.text = "No Water"
                print("i have no water")
        }
    }
    }
    
    override func viewDidLoad() {
        customedTabBarController = self.tabBarController as? BaseTabBarController
        customedTabBarController?.humidiferFirebase.homePageProtocol = self
        super.viewDidLoad()
        initializeBackGroundView()
        initializeCircleView()
        initializeHumidityLabel()
        initializeCurrentHumidityLabel()
        initializecurrentHumidityStatusLabel(humidity: 0.75)
        initlalizeHumidifierStatusLabel(status: "lalala")
        initlalizeRunningTimeLabel(status:"time")
        initializeSwitchButton(title: "Button")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        group.notify(queue: .main){
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.readHumidity(humidity: self.changePercentageToDouble(percentage: (self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.currentHumidity)!))
            if (self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.waterSufficient)! == false{
                self.buttonStatus = .noWater
            }else{
                if (self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.status)! == true{
                    self.buttonStatus = .on


                }else{
                    self.buttonStatus = .off
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.pulsatingLayer != nil{
            animatePulsatingLayer()
        }
    }
    
    ///backGroundPageview
    func initializeBackGroundView(){
        var backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        backgroundView.image = UIImage(named: "Triangle-Kids-Books" )
        self.view.backgroundColor = UIColor.darkPurple
        self.view.addSubview(backgroundView)
    }
    
    ///Progress Circle
    //https://www.youtube.com/watch?v=O3ltwjDJaMk
    func initializeCircleView() {
        
        let trackLayer = CAShapeLayer()
        let center = view.center
        let circlarPath = UIBezierPath(arcCenter: .zero, radius: self.view.frame.width/3, startAngle: 0, endAngle: 2.0*CGFloat.pi, clockwise: true)
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circlarPath.cgPath

        pulsatingLayer.lineWidth = 35
        
        pulsatingLayer.fillColor = UIColor.transpraintPurple.cgColor
        
        pulsatingLayer.lineCap = kCALineCapRound
        if Device.IS_IPAD{
            pulsatingLayer.position = CGPoint(x: view.center.x, y: view.center.y - self.view.frame.width/5)
        }else{
            pulsatingLayer.position = CGPoint(x: view.center.x, y: view.center.y - self.view.frame.width/3)
        }
        view.layer.addSublayer(pulsatingLayer)
        
        
        
        trackLayer.path = circlarPath.cgPath
        
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.lineWidth = 35
        
        trackLayer.fillColor = UIColor.darkPurple.cgColor
        
        trackLayer.lineCap = kCALineCapRound
        if Device.IS_IPAD{
            trackLayer.position = CGPoint(x: view.center.x, y: view.center.y - self.view.frame.width/5)
        }else{
            trackLayer.position = CGPoint(x: view.center.x, y: view.center.y - self.view.frame.width/3)
        }

        
        trackLayer.shadowOffset = CGSize(width: 0, height: 5)
        trackLayer.shadowRadius = 5
        trackLayer.shadowOpacity = 0.3
        trackLayer.shadowColor = UIColor.lightGray.cgColor
        
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circlarPath.cgPath
        
        shapeLayer.strokeColor = UIColor.brightPurple.cgColor
        
        shapeLayer.lineWidth = 35

        shapeLayer.lineDashPattern = [NSNumber(value: 30),NSNumber(value: 10)]

        shapeLayer.borderColor = UIColor.black.cgColor
        shapeLayer.borderWidth = 1
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.lineCap = kCALineCapButt

        shapeLayer.strokeEnd = 0
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        if Device.IS_IPAD{
            shapeLayer.position = CGPoint(x: view.center.x, y: view.center.y - self.view.frame.width/5)
        }else{
            shapeLayer.position = CGPoint(x: view.center.x, y: view.center.y - self.view.frame.width/3)
        }
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsating")
        
    }
    ///initialize the humidityLabel
    
    fileprivate func initializeHumidityLabel() {
        view.addSubview(humidityLabel)
        humidityLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        
        humidityLabel.center = CGPoint(x: self.view.center.x, y: self.shapeLayer.frame.maxY)
    }
    
    func initializeCurrentHumidityLabel()  {
        view.addSubview(currentHumidityLabel)
        currentHumidityLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        currentHumidityLabel.center = CGPoint(x: self.view.center.x, y: ((self.navigationController?.navigationBar.bounds.maxY)! + self.shapeLayer.bounds.minY)/2)
    }
    
    func initializecurrentHumidityStatusLabel(humidity:Double){

        currentHumidityStatusLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        currentHumidityStatusLabel.center = CGPoint(x: self.view.center.x, y: self.humidityLabel.frame.maxY)
        self.view.addSubview(currentHumidityStatusLabel)
 
    }
    
    
    func initlalizeHumidifierStatusLabel(status:String) {
        view.addSubview(humidifierStatusLabel)
        humidifierStatusLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30)
        humidifierStatusLabel.center = CGPoint(x: self.view.center.x, y: self.shapeLayer.frame.maxY + self.view.bounds.width/3 + 45)
    }
    
    func initlalizeRunningTimeLabel(status:String) {
        view.addSubview(runningTimeLabel)
        runningTimeLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50)
        runningTimeLabel.center = CGPoint(x: self.view.center.x, y: self.humidifierStatusLabel.frame.maxY + runningTimeLabel.frame.height/2)
    }
    
    func initializeSwitchButton(title:String){
        
        switchButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        switchButton.center = CGPoint(x: self.view.center.x, y: self.runningTimeLabel.frame.maxY + switchButton.frame.height/2)
        switchButton.addTarget(self,action: #selector(switchButtonWasPressed(_:)),for:.touchUpInside)
        view.addSubview(self.switchButton)
    }
    
    ///put humidity on the circle
    func readHumidity(humidity:Double){
        
        if humidity <= self.humidityStandards[0]{
            currentHumidityStatusLabel.text = self.currentStatus[0]
        }else if humidity <= self.humidityStandards[1]{
            currentHumidityStatusLabel.text = self.currentStatus[1]
        }else if humidity <= self.humidityStandards[2]{
            currentHumidityStatusLabel.text = self.currentStatus[2]
        }else{
            currentHumidityStatusLabel.text = self.currentStatus[3]
        }
        
        let basicAnimation =  CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = humidity
        self.humidityLabel.text = "\(Int(humidity*100))%"
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "Humidity")
    }

    @objc func switchButtonWasPressed(_ sender: Any) {
        if self.buttonStatus == .noWater{
            noWaterWarning()
        }else{
            if self.buttonStatus == .on{
                self.buttonStatus = .off
                self.customedTabBarController?.humidiferFirebase.setStatus(status: false)
            }else if buttonStatus == .off{
                if (customedTabBarController?.humidiferFirebase.myHumidifierStatus.timer.timerStatus)!{
//                    if customedTabBarController?.viewControllers![1].childViewControllers[0] != nil{
//                        let timerController = customedTabBarController?.viewControllers![1].childViewControllers[0] as! TimerController
//                            timerController.setButtonIsClicked(self)
//
//                    }else{
//                        print("")
//                    }
                    self.customedTabBarController?.humidiferFirebase.cancelTimer()
                }
                self.buttonStatus = .on
                self.customedTabBarController?.humidiferFirebase.setStatus(status: true)
                self.customedTabBarController?.humidiferFirebase.setTurnOnTime(time:NSDate())
            }
        }
        print("yeah i am touched")
        
    }
    
    func changePercentageToDouble(percentage:String) -> Double {
        var newpercentage = percentage
        
        newpercentage.remove(at: percentage.firstIndex(of: "%")!)
        var newDouble = Double(newpercentage)
        return newDouble!/100.00
    }
    
    
    func humidityChanged() {
        self.readHumidity(humidity: self.changePercentageToDouble(percentage: (self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.currentHumidity)!))
    }
    
    func waterSourceChange(waterStatus:Bool) {
        if waterStatus == false{
            self.buttonStatus = .off
            self.buttonStatus = .noWater
            noWaterWarning()
        }else{
            self.buttonStatus = .off
            self.humidifierStatusLabel.text = "Read To Go"
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
    
    @objc func startTimer(){
        let difference = abs((self.customedTabBarController?.humidiferFirebase.myHumidifierStatus.turnOnTime)!.timeIntervalSinceNow)
        self.runningTimeLabel.text = NSDate.stringFromTimeInterval(interval: difference)
    }
    

    

}
