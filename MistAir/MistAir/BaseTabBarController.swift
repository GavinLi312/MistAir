//
//  BaseTabBarController.swift
//  MistAir
//
//  Created by Michelle Zhu on 10/10/18.
//  Copyright © 2018 Gavin and Michelle. All rights reserved.
//


//how to create tab bar controller programatically: https://www.youtube.com/watch?v=1Sg7HjR_k2c

import UIKit

class BaseTabBarController: UITabBarController {

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
    
    //create the first controller: homepage
    func createHomePageController() -> UINavigationController{
        
        //create a homePageController [it is an empty UIView for now]
        let homePageController = UIViewController()
        
        //assign the homePageController as the root controller
        let homePageNavigationController = UINavigationController(rootViewController: homePageController)
        
        //tab bar item title
        homePageNavigationController.title = "Home"
        
        //tab bar item image when it is not selected
        homePageNavigationController.tabBarItem.image = UIImage(named: "homepage_empty-20")
        
        //tab bar item image when it is selected
        homePageNavigationController.tabBarItem.selectedImage = UIImage(named:"homepage-20")
        
        return homePageNavigationController
    }
    
    //create the second controller: timer
    func createTimerController() -> UINavigationController{
        
        //create a timerController [it is an empty UIView for now]
        let timerController = UIViewController()
        
        //assign the timerController as the root controller
        let timerNavigationController = UINavigationController(rootViewController: timerController)
        
        //tab bar item title
        timerNavigationController.title = "Timer"
        
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
        
        //tab bar item image when it is not selected
        moreNavigationController.tabBarItem.image = UIImage(named: "more-20")
        
        return moreNavigationController
    }

}
