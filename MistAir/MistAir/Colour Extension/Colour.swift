//
//  Colour.swift
//  MistAir
//
//  Created by Michelle Zhu on 10/10/18.
//  Copyright © 2018 Gavin and Michelle. All rights reserved.
//

import UIKit

//learned how to do uicolor extension class: https://medium.com/ios-os-x-development/ios-extend-uicolor-with-custom-colors-93366ae148e6

extension UIColor{
    
    //easy way to init a colour
    convenience init(red: Int, green: Int, blue: Int){
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid red component")
        assert(blue >= 0 && blue <= 255, "Invalid red component")
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    //hex way to init a colour
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    
    }
}
