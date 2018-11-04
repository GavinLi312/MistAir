//
//  CustomUISlider.swift
//  MistAir
//
//  Created by Michelle Zhu on 4/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit

//learn how to increase thickness for slide bar: https://stackoverflow.com/questions/23320179/make-uislider-height-larger

class CustomUISlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 12
        return newBounds
    }
}
