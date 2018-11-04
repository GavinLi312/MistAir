//
//  CircleSlider.swift
//  MistAir
//
//  Created by Salamender Li on 17/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit

class CircleSlider: UIView {
    
    let time =  12 * 60
    // * editable properties *
    var changeLabelProtocol:ReadTimeDelegate?
    // sizes
    var circle_diameter: CGFloat!
    var circle_width: CGFloat!
    var touch_diameter: CGFloat! // from end to end of the actual line
    var touch_tolerance: CGFloat! // number of pixels +/- off the circle line that the touch will register
    // colors
    var circle_color = UIColor.white
    var trail_color = UIColor.brightPurple
    // for ease of us    var dissappear_on_completion = false
    
    
    // selectors for actions, you know because this is a legit class
    enum CircleSliderAction { case touchMoved, touchFailed, circleCompleted }
    
    private var moved_target: NSObject?
    private var moved_selector: Selector?
    private var failed_target: NSObject?
    private var failed_selector: Selector?
    private var completed_target: NSObject?
    private var completed_selector: Selector?
    
    func setSelector(forAction action: CircleSliderAction, target: NSObject, selector: Selector) {
        switch action {
        case .touchMoved:
            moved_target = target
            moved_selector = selector
        case .touchFailed:
            failed_target = target
            failed_selector = selector
        case .circleCompleted:
            completed_target = target
            completed_selector = selector
        }
    }
    
    // * global variables for the class *
    
    // circle draw objects
    private var drawn_circle: UIBezierPath!
    private var inner_circle: UIBezierPath!
    private var outer_circle: UIBezierPath!
    
    // touching draw objects
    private var touch_circle: UIBezierPath!
    private var touch_trail: UIBezierPath!
    
    // circle maths things
    var circle_center: CGPoint!
    private var start_rad: CGFloat?
    private var end_rad: CGFloat?
    // testing variables
    var start_point: CGPoint?
    var end_point:CGPoint?
    
    
    var beginImageView:UIImageView!
    
    var endImageView:UIImageView!
    
    // * Functions to start the things *
    
    func makeSlider() -> Bool {
        // prep and draw the circle, returns false if the view is too small for the properties
        self.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        if circle_width == nil { circle_width = self.frame.width / 10 }
        //        if touch_diameter == nil { touch_diameter = self.frame.width / 8 }
        if touch_tolerance == nil { touch_tolerance = self.frame.width / 7 }
        if circle_diameter == nil { circle_diameter = self.frame.width - (touch_tolerance * 2) }
        
        if (circle_diameter + (touch_tolerance * 2)) > (self.frame.width) { return false }
        
        circle_center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        drawn_circle = UIBezierPath(arcCenter: circle_center, radius: (circle_diameter / 2),
                                    startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        drawn_circle.lineWidth = circle_width
        
        outer_circle = UIBezierPath(arcCenter: circle_center, radius: (circle_diameter / 2) + touch_tolerance,
                                    startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        inner_circle = UIBezierPath(arcCenter: circle_center, radius: (circle_diameter / 2) - touch_tolerance,
                                    startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        var startpoint = CGPoint(x: circle_center.x, y: circle_center.y - circle_diameter/2)
        if start_point == nil{
            
            start_point = getPointOnCircle(forPoint: startpoint)
        }
        
        if end_point == nil{
            end_point = getPointOnCircle(forPoint: startpoint)
        }
        beginImageView = UIImageView(frame: CGRect(x: start_point!.x, y: start_point!.y, width: circle_width, height: circle_width))
        endImageView = UIImageView(frame: CGRect(x: start_point!.x, y: start_point!.y, width: circle_width, height: circle_width))
        self.setNeedsDisplay()
        return true
    }
    
    //    // * override the things  *
    
    override func draw(_ rect: CGRect) {
        guard inner_circle != nil else {
            print("can't draw yet because circle beziers have not been made")
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        context!.clear(self.bounds)
        initializeStartImageView()
        initializeEndImageView()
        circle_color.setStroke()
        drawn_circle.stroke()
        if touch_trail != nil { trail_color.setStroke(); touch_trail.stroke() }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!.location(in: self)
        
        if checkPointInTheCircle(Point: touch, Center: self.start_point!, Radius: self.circle_width/2){
            print("yes, i am touched")
            startTouch(atPoint: touch)
        }else if checkPointInTheCircle(Point: touch, Center: self.end_point!, Radius: self.circle_width/2){
            startTouch(atPoint: touch)
        }
    }
    
    func checkPointInTheCircle(Point point:CGPoint,Center center:CGPoint, Radius rad:CGFloat ) -> Bool{
        let xDist = (point.x - center.x);
        let yDist = (point.y - center.y);
        let distance = sqrt(xDist * xDist + yDist * yDist);
        if distance < rad{
            return true
        }else{
            return false
        }
    }
    
    
    func initializeStartImageView() -> UIImageView {
        if self.beginImageView != nil{
            if self.subviews.contains(beginImageView!){
                self.beginImageView?.removeFromSuperview()
            }
        }
        let image = UIImage(named: "homepage_empty-20")
        
        beginImageView!.contentMode = .scaleToFill
        beginImageView!.tintColor = UIColor.authBackgroundPurple
        beginImageView?.backgroundColor = UIColor.authBackgroundPurple
        beginImageView!.image = image
        beginImageView!.layer.cornerRadius = 0.5 * beginImageView!.bounds.size.width
        beginImageView!.layer.borderColor = UIColor.brightPurple.withAlphaComponent(0.8).cgColor
        beginImageView!.layer.borderWidth = 1
        beginImageView!.center = start_point!
        self.addSubview(beginImageView!)
        self.bringSubview(toFront: beginImageView!)
        return beginImageView!
    }
    
    
    func initializeEndImageView() -> UIImageView {
        if self.endImageView != nil{
            if self.subviews.contains(endImageView!){
                self.endImageView?.removeFromSuperview()
            }
        }
        let image = UIImage(named: "homepage_empty-20")
        
        endImageView!.contentMode = .scaleToFill
        endImageView!.tintColor = UIColor.authBackgroundPurple
        endImageView?.backgroundColor = UIColor.authBackgroundPurple
        endImageView!.image = image
        endImageView!.layer.cornerRadius = 0.5 * endImageView!.bounds.size.width
        endImageView!.layer.borderColor = UIColor.brightPurple.withAlphaComponent(0.8).cgColor
        endImageView!.layer.borderWidth = 2
        endImageView!.center = end_point!
        self.addSubview(endImageView!)
        self.bringSubview(toFront: endImageView!)
        return endImageView!
    }
    
    private func pointOnCircle(forRad rad: CGFloat, withRadius radius: CGFloat) -> CGPoint {
        let x = radius * cos(rad)
        let y = radius * sin(rad)
        return CGPoint(x: x + circle_center.x, y: y + circle_center.y)
    }
    
    private func getPointOnCircle(forPoint point: CGPoint) -> CGPoint {
        let touchPoint = CGPoint(x: point.x - circle_center.x, y: point.y - circle_center.y)
        
        let touchRad = atan2(touchPoint.y, touchPoint.x)
        return pointOnCircle(forRad: touchRad, withRadius: circle_diameter / 2)
    }
    
    private func startTouch(atPoint point: CGPoint) {
        endTouching()
        updateTouchTrail()
        
        self.setNeedsDisplay()
    }
    
    private func endTouching() {
        start_rad = nil
        end_rad = nil
        
        touch_circle = nil
        touch_trail = nil
        
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!.location(in: self)
        
        if checkPointInTheCircle(Point: touch, Center: self.start_point!, Radius: self.circle_width/2){
            moveTouch(toPoint: touch, whichpoint: "start")
            print("yes i am moving")
        } else  if checkPointInTheCircle(Point: touch, Center: self.end_point!, Radius: self.circle_width/2){
            moveTouch(toPoint: touch, whichpoint: "end")
            
        }else{
            touchFailed()
            print("faile")
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        updateTouchTrail()
    }
    private func moveTouch(toPoint point: CGPoint,whichpoint option:String) {
        let circlePoint = getPointOnCircle(forPoint: point)

        if option == "start"{
            start_point = circlePoint
        }else{
            end_point = circlePoint
        }
        updateTouchTrail()
        

        
        self.setNeedsDisplay()
    }
    
    
    func updateTouchTrail() {
        let beginRad = atan2(start_point!.y - circle_center.y, start_point!.x - circle_center.x)
        let endRad = atan2(end_point!.y - circle_center.y, end_point!.x - circle_center.x)
        touchMoved(rad: beginRad)
        touchMoved(rad: endRad)
        start_rad = beginRad
        end_rad = endRad
        guard start_rad != nil else { start_rad = beginRad; return }
        guard end_rad != nil else {end_rad = endRad; return}
        
        touch_trail = UIBezierPath(arcCenter: circle_center, radius: (circle_diameter / 2),
                                   startAngle: start_rad!, endAngle: end_rad!, clockwise: true)
        touch_trail.lineWidth = circle_width
        let startTime = getMinutesFromAngle(angle: start_rad!)
        let endTime = getMinutesFromAngle(angle: end_rad!)
        
        var duration = endTime - startTime
        if duration < 0 {
            duration = duration + 720
        }
        self.changeLabelProtocol?.changeLabel(startMinute: startTime, Duration: duration)
    }

    private func touchFailed() {
        endTouching()
        self.updateTouchTrail()
    }
    
    private func touchMoved(rad: CGFloat) {
        if moved_target != nil && moved_selector != nil { moved_target!.performSelector(inBackground: moved_selector!, with: (rad as AnyObject)) }
    }
    
    func getMinutesFromAngle(angle : CGFloat) -> Int {
        var percentage : CGFloat!
        var newAngle = angle + CGFloat.pi/2
        if newAngle > 0{
            percentage = (newAngle)/(CGFloat.pi * 2)
        }else{
            newAngle = newAngle + 2*CGFloat.pi
            percentage = (newAngle)/(CGFloat.pi * 2)
        }
        let minutes = percentage * CGFloat(self.time)
        return Int(minutes)
    }
    
    func getAngleFromMinute(minute:Int) -> CGFloat{
        var angle : CGFloat!
        var percentage = CGFloat(minute)/CGFloat(self.time)
        angle = percentage * 2 * CGFloat.pi
        return angle
    }
}
