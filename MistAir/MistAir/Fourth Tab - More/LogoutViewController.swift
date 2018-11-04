//
//  LogoutViewController.swift
//  MistAir
//
//  Created by Michelle Zhu on 4/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit
import Firebase

class LogoutViewController: UIViewController{

    
    //programatical UI
    //the logout label
    let logoutLabel: UILabel = {
        let logout = UILabel()
        logout.text = "LOG OUT"
        logout.textColor = UIColor.authTextYellow
        logout.font = UIFont.boldSystemFont(ofSize: 28)
        logout.adjustsFontSizeToFitWidth = true
        logout.minimumScaleFactor = 0.5
        logout.lineBreakMode = .byWordWrapping
        logout.numberOfLines = 0
        logout.textAlignment = .center
        return logout
    }()
    
    
    //the login box
    let loginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.authBackgroundPurple
        return view
    }()
    
    //humidifier ID UIView
    let humidifierIDView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let humidifierIDLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkPurple
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "HUMIDIFIER ID"
        return label
    }()
    
    let humidifierIDTextField: UITextField = {
        let textfield = UITextField()
        textfield.isEnabled = false
        textfield.font = UIFont.systemFont(ofSize: 17)
        textfield.textColor = UIColor.customGrey
        textfield.contentVerticalAlignment = .center
        return textfield
    }()
    
    
    //email UIView
    let emailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkPurple
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "EMAIL"
        return label
    }()
    
    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.isEnabled = false
        textfield.font = UIFont.systemFont(ofSize: 17)
        textfield.textColor = UIColor.customGrey
        textfield.contentVerticalAlignment = .center
        return textfield
    }()

    
    //logout button
    let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightPurple
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set background colour
        view.backgroundColor = UIColor.darkPurple
        
        //setup UI
        setupLoginBox()
        setupLogoutLabel()
        setupHumidifierIDView()
        setupEmailView()
        setupLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fill in the id
        if let id = UserDefaults.standard.string(forKey: "Humidifier ID"){
            humidifierIDTextField.text = id
        }
        
        //fill in email
        emailTextField.text = Auth.auth().currentUser?.email
    }
    
    
    //setup login box
    func setupLoginBox(){
        self.view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        var width = 300
        let height = 410
        if Device.IS_IPHONE_5{
            width = 260
        }
        loginView.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
    }
    
    
    //setup welcome label
    func setupLogoutLabel(){
        self.view.addSubview(logoutLabel)
        logoutLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutLabel.bottomAnchor.constraint(equalTo: self.loginView.topAnchor, constant: -8).isActive = true
        logoutLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoutLabel.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 0).isActive = true
        logoutLabel.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: 0).isActive = true
    }
    
    //setup humidifier id view
    func setupHumidifierIDView(){
        //add subview
        self.loginView.addSubview(humidifierIDView)
        humidifierIDView.addSubview(humidifierIDLabel)
        humidifierIDView.addSubview(humidifierIDTextField)
        
        humidifierIDView.translatesAutoresizingMaskIntoConstraints = false
        humidifierIDLabel.translatesAutoresizingMaskIntoConstraints = false
        humidifierIDTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintForHumidifierIDView()
        addConstraintForHumidifierIDLabel()
        addConstraintForHumidifierIDTextField()
    }
    
    private func addConstraintForHumidifierIDView(){
        //add constraint for humidifierID view
        humidifierIDView.topAnchor.constraint(equalTo: self.loginView.topAnchor, constant: 24).isActive = true
        humidifierIDView.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 16).isActive = true
        humidifierIDView.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: -16).isActive = true
        humidifierIDView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func addConstraintForHumidifierIDLabel(){
        humidifierIDLabel.topAnchor.constraint(equalTo: self.humidifierIDView.topAnchor, constant: 4).isActive = true
        humidifierIDLabel.leftAnchor.constraint(equalTo: self.humidifierIDView.leftAnchor, constant: 8).isActive = true
        humidifierIDLabel.rightAnchor.constraint(equalTo: self.humidifierIDView.rightAnchor, constant: -8).isActive = true
        humidifierIDLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    private func addConstraintForHumidifierIDTextField(){
        humidifierIDTextField.topAnchor.constraint(equalTo: self.humidifierIDLabel.bottomAnchor, constant: 4).isActive = true
        humidifierIDTextField.leftAnchor.constraint(equalTo: self.humidifierIDView.leftAnchor, constant: 8).isActive = true
        humidifierIDTextField.rightAnchor.constraint(equalTo: self.humidifierIDView.rightAnchor, constant: -8).isActive = true
        humidifierIDTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    //setup email view
    func setupEmailView(){
        //add subview
        self.loginView.addSubview(emailView)
        emailView.addSubview(emailLabel)
        emailView.addSubview(emailTextField)
        
        emailView.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintForEmailView()
        addConstraintForEmailLabel()
        addConstraintForEmailTextField()
    }
    
    private func addConstraintForEmailView(){
        //add constraint for email view
        emailView.topAnchor.constraint(equalTo: self.humidifierIDView.bottomAnchor, constant: 16).isActive = true
        emailView.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 16).isActive = true
        emailView.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: -16).isActive = true
        emailView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func addConstraintForEmailLabel(){
        emailLabel.topAnchor.constraint(equalTo: self.emailView.topAnchor, constant: 4).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: self.emailView.leftAnchor, constant: 8).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: self.emailView.rightAnchor, constant: -8).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    private func addConstraintForEmailTextField(){
        emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 4).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: self.emailView.leftAnchor, constant: 8).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: self.emailView.rightAnchor, constant: -8).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    
    //setup logout button
    func setupLogoutButton(){
        self.loginView.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.bottomAnchor.constraint(equalTo: self.loginView.bottomAnchor, constant: -24).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 16).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: -16).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //add an action to the button
        logoutButton.addTarget(self,action: #selector(logoutAccount(_:)),for:.touchUpInside)
    }
    
    @objc func logoutAccount(_ sender: Any){
        do{
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch{
            print(error)
        }
    }

}
