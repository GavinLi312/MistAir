//
//  HLSettingViewController.swift
//  MistAir
//
//  Created by Michelle Zhu on 4/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit
import Firebase

class HLSettingViewController: UIViewController {

    //draw UI programatically
    
    //for maximum level setting
    let maxHLView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let maxImage: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "HL mode-40")
        return icon
    }()
    
    let maxLabel: UILabel = {
       let label = UILabel()
        label.text = "MAXIMUM HUMIDITY LEVEL"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let maxLevelLabel: UILabel = {
       let label = UILabel()
        label.text = "80%"
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = UIColor.white
        return label
    }()
    
    let maxSlider: CustomUISlider = {
       let slider = CustomUISlider()
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.minimumTrackTintColor = UIColor.brightPurple
        slider.maximumTrackTintColor = UIColor.white
        slider.setValue(80.0, animated: true)
        return slider
    }()
    
    //for minimum level setting
    let minHLView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let minImage: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "HL mode-40")
        return icon
    }()
    
    let minLabel: UILabel = {
        let label = UILabel()
        label.text = "MINIMUM HUMIDITY LEVEL"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let minLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "50%"
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = UIColor.white
        return label
    }()
    
    let minSlider: CustomUISlider = {
        let slider = CustomUISlider()
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.minimumTrackTintColor = UIColor.brightPurple
        slider.maximumTrackTintColor = UIColor.white
        slider.setValue(50.0, animated: true)
        return slider
    }()
    
    //explanation label
    let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = "When the maximum/minimum level is reached, the app turns off/on the humidifier automatically (if HL Mode or PD Mode is on)."
        label.textColor = UIColor.customGrey
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background colour
        self.view.backgroundColor = UIColor.darkPurple
        
        //navigation item title
        self.navigationItem.title = "Humidity Level Setting"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"tick-20"), style: .done, target: nil, action: nil)
        
        setupMaxHLview()
        setupMinHLview()
        setupExplanationLabel()
    }
    
    //setup maximum HL
    private func setupMaxHLview(){
        //add subview
        self.view.addSubview(maxHLView)
        self.maxHLView.addSubview(maxImage)
        self.maxHLView.addSubview(maxLabel)
        self.maxHLView.addSubview(maxLevelLabel)
        self.maxHLView.addSubview(maxSlider)
        
        //to allow constraint setup
        maxHLView.translatesAutoresizingMaskIntoConstraints = false
        maxImage.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        maxSlider.translatesAutoresizingMaskIntoConstraints = false
        
        //setup constraint
        addConstraintForMaxHLView()
        addConstraintForMaxImage()
        addConstraintForMaxLabel()
        addConstraintForMaxLevelLabel()
        addConstraintForMaxSlider()
    }
    
    private func addConstraintForMaxHLView(){
        maxHLView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        maxHLView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        maxHLView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        maxHLView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    private func addConstraintForMaxImage(){
        maxImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        maxImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        maxImage.leftAnchor.constraint(equalTo: self.maxHLView.leftAnchor, constant: 8).isActive = true
        maxImage.topAnchor.constraint(equalTo: self.maxHLView.topAnchor, constant: 8).isActive = true
    }
    
    private func addConstraintForMaxLabel(){
        maxLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        maxLabel.leftAnchor.constraint(equalTo: self.maxImage.rightAnchor, constant: 8).isActive = true
        maxLabel.rightAnchor.constraint(equalTo: self.maxHLView.rightAnchor, constant: -8).isActive = true
        maxLabel.topAnchor.constraint(equalTo: self.maxHLView.topAnchor, constant: 8).isActive = true
    }
    
    private func addConstraintForMaxLevelLabel(){
        maxLevelLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        maxLevelLabel.leftAnchor.constraint(equalTo: self.maxHLView.leftAnchor, constant: 8).isActive = true
        maxLevelLabel.rightAnchor.constraint(equalTo: self.maxHLView.rightAnchor, constant: -8).isActive = true
        maxLevelLabel.topAnchor.constraint(equalTo: self.maxImage.bottomAnchor, constant: 16).isActive = true
    }
    
    private func addConstraintForMaxSlider(){
        maxSlider.heightAnchor.constraint(equalToConstant: 55).isActive = true
        maxSlider.leftAnchor.constraint(equalTo: self.maxHLView.leftAnchor, constant: 8).isActive = true
        maxSlider.rightAnchor.constraint(equalTo: self.maxHLView.rightAnchor, constant: -8).isActive = true
        maxSlider.topAnchor.constraint(equalTo: self.maxLevelLabel.bottomAnchor, constant: 8).isActive = true
        
        //add an action to the slider
        maxSlider.addTarget(self,action: #selector(slideMaxLevel(_:)),for:.touchDragInside)
    }

    @objc func slideMaxLevel(_ sender: Any){
        maxLevelLabel.text = "\(Int(maxSlider.value))%"
    }
    
    //setup minimum HL
    private func setupMinHLview(){
        //add subview
        self.view.addSubview(minHLView)
        self.minHLView.addSubview(minImage)
        self.minHLView.addSubview(minLabel)
        self.minHLView.addSubview(minLevelLabel)
        self.minHLView.addSubview(minSlider)
        
        //to allow constraint setup
        minHLView.translatesAutoresizingMaskIntoConstraints = false
        minImage.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        minLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        minSlider.translatesAutoresizingMaskIntoConstraints = false
        
        //setup constraint
        addConstraintForMinHLView()
        addConstraintForMinImage()
        addConstraintForMinLabel()
        addConstraintForMinLevelLabel()
        addConstraintForMinSlider()
    }
    
    private func addConstraintForMinHLView(){
        minHLView.topAnchor.constraint(equalTo: self.maxHLView.bottomAnchor, constant: 16).isActive = true
        minHLView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        minHLView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        minHLView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func addConstraintForMinImage(){
        minImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        minImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        minImage.leftAnchor.constraint(equalTo: self.minHLView.leftAnchor, constant: 8).isActive = true
        minImage.topAnchor.constraint(equalTo: self.minHLView.topAnchor, constant: 8).isActive = true
    }
    
    private func addConstraintForMinLabel(){
        minLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        minLabel.leftAnchor.constraint(equalTo: self.minImage.rightAnchor, constant: 8).isActive = true
        minLabel.rightAnchor.constraint(equalTo: self.minHLView.rightAnchor, constant: -8).isActive = true
        minLabel.topAnchor.constraint(equalTo: self.minHLView.topAnchor, constant: 8).isActive = true
    }
    
    private func addConstraintForMinLevelLabel(){
        minLevelLabel.heightAnchor.constraint(equalToConstant: 55).isActive = true
        minLevelLabel.leftAnchor.constraint(equalTo: self.minHLView.leftAnchor, constant: 8).isActive = true
        minLevelLabel.rightAnchor.constraint(equalTo: self.minHLView.rightAnchor, constant: -8).isActive = true
        minLevelLabel.topAnchor.constraint(equalTo: self.minImage.bottomAnchor, constant: 16).isActive = true
    }
    
    private func addConstraintForMinSlider(){
        minSlider.heightAnchor.constraint(equalToConstant: 55).isActive = true
        minSlider.leftAnchor.constraint(equalTo: self.minHLView.leftAnchor, constant: 8).isActive = true
        minSlider.rightAnchor.constraint(equalTo: self.minHLView.rightAnchor, constant: -8).isActive = true
        minSlider.topAnchor.constraint(equalTo: self.minLevelLabel.bottomAnchor, constant: 8).isActive = true
        
        //add an action to the slider
        minSlider.addTarget(self,action: #selector(slideMinLevel(_:)),for:.touchDragInside)
    }
    
    @objc func slideMinLevel(_ sender: Any){
        minLevelLabel.text = "\(Int(minSlider.value))%"
    }
    
    //seu up explanation label
    private func setupExplanationLabel(){
        self.view.addSubview(self.explanationLabel)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        explanationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        explanationLabel.topAnchor.constraint(equalTo: self.minHLView.bottomAnchor, constant: 8).isActive = true
        explanationLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 8).isActive = true
    }
    
}
