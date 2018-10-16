//
//  TimerController.swift
//  MistAir
//
//  Created by Salamender Li on 17/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit

class TimerController: UIViewController {

    let shapeLayer = CAShapeLayer()
    var pulsatingLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBackGroundView()
        initializeCircleView()
        addImageToTheCircle()
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
        
        //        pulsatingLayer.strokeColor = UIColor.white.cgColor
        pulsatingLayer.lineWidth = 35
        
        pulsatingLayer.fillColor = UIColor.transpraintPurple.cgColor
        
        pulsatingLayer.lineCap = kCALineCapRound

        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
//        
//        animatePulsatingLayer()
        
        trackLayer.path = circlarPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 35
        
        trackLayer.fillColor = UIColor.darkPurple.cgColor
        
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
        
        
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
        shapeLayer.position = view.center
        
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
    
    func addImageToTheCircle()  {
        let image = UIImage(named: "homepage_empty-20" )
        let imageView = UIImageView(frame: CGRect(x: self.shapeLayer.position.x, y: self.shapeLayer.position.y, width: 35, height: 35))
        imageView.image = image
        imageView.center = CGPoint(x: self.shapeLayer.position.x, y: self.shapeLayer.position.y - self.view.frame.width/3)
        self.view.addSubview(imageView)
        self.view.bringSubview(toFront: imageView)
    }


}
