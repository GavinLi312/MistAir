//
//  HomePageController.swift
//  MistAir
//
//  Created by Salamender Li on 15/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit

class HomePageController: UIViewController {

    var homePageView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.title = "Home Page"

        initializeBackGroundView()
    }
    
    
    ///backGroundPageview
    func initializeBackGroundView(){
        var backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        backgroundView.image = UIImage(named: "Triangle-Kids-Books" )
        self.view.addSubview(backgroundView)
        self.view.bringSubview(toFront: backgroundView)
    }
    
    ///

}
