//
//  BaseTabBarController.swift
//  MistAir
//
//  Created by Michelle Zhu on 10/10/18.
//  Copyright © 2018 Gavin and Michelle. All rights reserved.
//


//how to create tab bar controller programatically: https://www.youtube.com/watch?v=1Sg7HjR_k2c

import UIKit
import FirebaseDatabase


//https://gist.github.com/mahmudahsan/bcc1272433e38f1efd3c2389c75cd00f github detect current Iphone device
struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}



class BaseTabBarController: UITabBarController {

    var humidiferFirebase = HumidifierFirebase()
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up tab bar
        setupTabBar()
        

        //add controllers to tab bar controllers
        viewControllers = [createHomePageController(),createTimerController(),createStatisticsController(),createMoreController()]
    }

    func setupTabBar(){
        //modify background colour of tab bar
        tabBar.barTintColor = UIColor.lightPurple
        
        //modify tint colour of tab bar item (when selected)
        tabBar.tintColor = UIColor.buttonPurple
        
        //set tint colour for tab bar item when they are not selected
        tabBar.unselectedItemTintColor = UIColor.white
        
        //change to not translucent to get correct colour
        tabBar.isTranslucent = false
    }
    
    ///create the first controller: homepage
    func createHomePageController() -> UINavigationController{
        
        //create a homePageController [it is an empty UIView for now]
        let homePageController = HomePageController()
        
        //assign the homePageController as the root controller
        let homePageNavigationController = UINavigationController(rootViewController: homePageController)
        
        //tab bar item title
        homePageNavigationController.title = "Home"
        
        //set up navgigationItem title
        homePageController.navigationItem.title = "Home"
        
        //tab bar item image when it is not selected
        homePageNavigationController.tabBarItem.image = UIImage(named: "homepage_empty-20")
        
        //tab bar item image when it is selected
        homePageNavigationController.tabBarItem.selectedImage = UIImage(named:"homepage-20")
        
        return homePageNavigationController
    }
    
    //create the second controller: timer
    func createTimerController() -> UINavigationController{
        
        //create a timerController [it is an empty UIView for now]
        let timerController = TimerController()
        
        //assign the timerController as the root controller
        let timerNavigationController = UINavigationController(rootViewController: timerController)
        
        //tab bar item title
        timerNavigationController.title = "Timer"
        
        //set up NavigationItem Title
        timerController.navigationItem.title = "Timer"
        
        //tab bar item image when it is not selected
        timerNavigationController.tabBarItem.image = UIImage(named: "timer-20")
        
        return timerNavigationController
    }
    
    //create the third controller: statistics
    func createStatisticsController() -> UINavigationController{
        
        //create a StatisticsController [it is an empty UIView for now]
        let statisticsController = UIViewController()
        
        //assign the StatisticsController as the root controller
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        
        //tab bar item title
        statisticsNavigationController.title = "Statistics"
        
        //set up NavigationItem Title
        statisticsController.navigationItem.title = "Statistics"
        
        //tab bar item image when it is not selected
        statisticsNavigationController.tabBarItem.image = UIImage(named: "graph_empty-20")
        
        //tab bar item image when it is selected
        statisticsNavigationController.tabBarItem.selectedImage = UIImage(named:"graph-20")
        
        return statisticsNavigationController
    }
    
    
    //create the fourth controller: more
    func createMoreController() -> UINavigationController{
        
        //create a moreController [it is an empty UIView for now]
        let moreController = UIViewController()
        
        //assign the moreController as the root controller
        let moreNavigationController = UINavigationController(rootViewController: moreController)
        
        //tab bar item title
        moreNavigationController.title = "More"
        
        //set up NavigationItem Title
        moreController.navigationItem.title = "More"
        
        //tab bar item image when it is not selected
        moreNavigationController.tabBarItem.image = UIImage(named: "more-20")
        
        return moreNavigationController
    }
    
    @objc func readDataFromFirebase()  {
        self.humidiferFirebase = HumidifierFirebase()
    }
    
}
