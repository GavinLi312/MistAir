//
//  AboutViewController.swift
//  MistAir
//
//  Created by Salamender Li on 5/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "MistAir"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = UIColor.white
        return label
        
    }()
    
    let developerInfo : UILabel = {
        let label = UILabel()
        label.text = "Gavin & Michelle  Version1.0"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.customGrey
        return label
        
    }()
    
    let introductionLabel : UILabel = {
        let label = UILabel()
        label.text = "MistAir is a smart humidifier aiming to bring ease and comfort to users who would enjoy more mist in the air with one tap with the phone."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.textAlignment = .justified
        return label
    }()
    
    let creditLabel : UILabel = {
        let label = UILabel()
        label.text = "Credits"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = UIColor.white
        return label
        
    }()
    
    let sponsorsLabel : UILabel = {
        let label = UILabel()
        label.text = "Firebase | Raspberry Pi | Github | Flaticon | Youtube tutorials | StackOverflow | Charts"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.textAlignment = .justified
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBackGroundView()
        initializeTitleLabel()
        initializeDevelopInfo()
        initializeIntroductionLabel()
        initializeCreditLabel()
        initializeSponsorsLabel()
    }
    
    ///backGroundPageview
    func initializeBackGroundView(){
        var backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.navigationItem.title = "About"
        self.view.backgroundColor = UIColor.darkPurple
        self.view.addSubview(backgroundView)
    }

    func initializeTitleLabel(){
        self.view.addSubview(self.titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        
    }
    
    func initializeDevelopInfo(){
        self.view.addSubview(self.developerInfo)
        developerInfo.translatesAutoresizingMaskIntoConstraints = false
        self.developerInfo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.developerInfo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.developerInfo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.developerInfo.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 3).isActive = true
        }
    
    func initializeIntroductionLabel(){
        self.view.addSubview(self.introductionLabel)
        self.introductionLabel.translatesAutoresizingMaskIntoConstraints = false

        
        if Device.IS_IPHONE_5 {
        self.introductionLabel.widthAnchor.constraint(equalTo:self.view!.widthAnchor , constant: -32).isActive = true
        }else{
                self.introductionLabel.widthAnchor.constraint(equalTo:self.view!.widthAnchor, constant: -100).isActive = true
        }
        
        self.introductionLabel.topAnchor.constraint(equalTo: self.developerInfo.bottomAnchor, constant: 20).isActive = true
        self.introductionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func initializeCreditLabel(){
        self.view.addSubview(self.creditLabel)
        self.creditLabel.translatesAutoresizingMaskIntoConstraints = false
        self.creditLabel.widthAnchor.constraint(equalTo: self.titleLabel.widthAnchor).isActive = true
        self.creditLabel.heightAnchor.constraint(equalTo: self.titleLabel.heightAnchor).isActive = true
        self.creditLabel.topAnchor.constraint(equalTo: self.introductionLabel.bottomAnchor, constant: 30).isActive = true
        self.creditLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    func initializeSponsorsLabel() {
        self.view.addSubview(self.sponsorsLabel)
        self.sponsorsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sponsorsLabel.widthAnchor.constraint(equalTo: self.introductionLabel.widthAnchor).isActive = true
        self.sponsorsLabel.topAnchor.constraint(equalTo: self.creditLabel.bottomAnchor, constant: 30).isActive = true
        self.sponsorsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}
