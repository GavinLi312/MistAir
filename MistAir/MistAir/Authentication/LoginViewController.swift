//
//  LoginViewController.swift
//  MistAir
//
//  Created by Michelle Zhu on 2/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    //firebase authentication handler
    var handle: AuthStateDidChangeListenerHandle?
    
    //programatical UI
    //the welcome label
    let welcomeLabel: UILabel = {
        let welcome = UILabel()
        welcome.text = ""
        welcome.textColor = UIColor.authTextYellow
        welcome.font = UIFont.boldSystemFont(ofSize: 28)
        welcome.lineBreakMode = .byWordWrapping
        welcome.numberOfLines = 0
        welcome.textAlignment = .center
        return welcome
    }()
    
    //the login box
    let loginView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.authBackgroundPurple
        return view
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
        textfield.keyboardType = .emailAddress
        textfield.font = UIFont.systemFont(ofSize: 17)
        textfield.textColor = UIColor.customGrey
        textfield.contentVerticalAlignment = .center
        textfield.clearButtonMode = .whileEditing
        textfield.autocapitalizationType = .none
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Enter email address"
        return textfield
    }()
    
    //password UIView
    let passwordView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkPurple
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "PASSWORD"
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = .default
        textfield.isSecureTextEntry = true
        textfield.font = UIFont.systemFont(ofSize: 17)
        textfield.textColor = UIColor.customGrey
        textfield.contentVerticalAlignment = .center
        textfield.clearButtonMode = .whileEditing
        textfield.autocapitalizationType = .none
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Enter password"
        return textfield
    }()
    
    //register button
    let registerButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor.lightPurple
        button.setTitle("REGISTER", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    //login button
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightPurple
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    //forgot password button
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        //button.setTitle("Forgot your password?", for: .normal)
        button.setTitleColor(UIColor.customGrey, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        //button.setAttributedTitle(self.attributedString, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Forgot your password?", attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: UIColor.customGrey,
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.underlineColor: UIColor.customGrey
            ]), for: .normal)
        return button
        }()
    
    //for the underline button text
    let attributedString: NSAttributedString = {
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: UIColor.customGrey,
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.underlineColor: UIColor.customGrey
            ]
        let attributedString = NSAttributedString(string: "Forgot your password?", attributes: attributes)
        return attributedString
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        //set background colour
        view.backgroundColor = UIColor.darkPurple

        //setup UI
        setupLoginBox()
        setupWelcomeLabel()
        setupEmailView()
        setupPasswordView()
        setupLoginButton()
        setupRegisterButton()
        setupForgotPasswordButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener({(auth,user)in
            if user != nil{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    

    //setup login box
    func setupLoginBox(){
        self.view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        var width = 300
        var height = 410
        if Device.IS_IPHONE_5{
            width = 260
            height = 355
        }
        loginView.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
    }
    
    
    //setup welcome label
    func setupWelcomeLabel(){
        self.view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "WELCOME TO \n MISTAIR"
        if Device.IS_IPAD{
            welcomeLabel.text = "WELCOME TO MISTAIR"
        }
        welcomeLabel.bottomAnchor.constraint(equalTo: self.loginView.topAnchor, constant: -8).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
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
        emailView.topAnchor.constraint(equalTo: self.loginView.topAnchor, constant: 32).isActive = true
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
    
    //setup password view
    func setupPasswordView(){
        //add subview
        self.loginView.addSubview(passwordView)
        passwordView.addSubview(passwordLabel)
        passwordView.addSubview(passwordTextField)
        
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintForpasswordView()
        addConstraintForpasswordLabel()
        addConstraintForpasswordTextField()
    }
    
    private func addConstraintForpasswordView(){
        //add constraint for password view
        passwordView.topAnchor.constraint(equalTo: self.emailView.bottomAnchor, constant: 16).isActive = true
        passwordView.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 16).isActive = true
        passwordView.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: -16).isActive = true
        passwordView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func addConstraintForpasswordLabel(){
        passwordLabel.topAnchor.constraint(equalTo: self.passwordView.topAnchor, constant: 4).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: self.passwordView.leftAnchor, constant: 8).isActive = true
        passwordLabel.rightAnchor.constraint(equalTo: self.passwordView.rightAnchor, constant: -8).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    private func addConstraintForpasswordTextField(){
        passwordTextField.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 4).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: self.passwordView.leftAnchor, constant: 8).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: self.passwordView.rightAnchor, constant: -8).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    //setup login button
    func setupLoginButton(){
        self.loginView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.bottomAnchor.constraint(equalTo: self.loginView.bottomAnchor, constant: -32).isActive = true
        loginButton.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 16).isActive = true
        loginButton.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: -16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //setup register button
    func setupRegisterButton(){
        self.loginView.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -16).isActive = true
        registerButton.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 16).isActive = true
        registerButton.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: -16).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //setup forgot password button
    func setupForgotPasswordButton(){
        self.view.addSubview(forgotPasswordButton)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.topAnchor.constraint(equalTo: self.loginView.bottomAnchor, constant: 8).isActive = true
        forgotPasswordButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        forgotPasswordButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    
    //hide keyboard when press return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func registerAccount(_ sender: Any) {
        guard let password = passwordTextField.text else{
            displayErrorMessage("Please enter a password")
            return
        }
        guard let email = emailTextField.text else{
            displayErrorMessage("Please enter an email address")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password){(user,error) in
            if error != nil{
                self.displayErrorMessage(error!.localizedDescription)
            }
        }
    }
    
    @objc func loginAccount(_ sender: Any) {
        guard let password = passwordTextField.text else{
            displayErrorMessage("Please enter a password")
            return
        }
        guard let email = emailTextField.text else{
            displayErrorMessage("Please enter an email address")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password){(user,error) in
            if error != nil{
                self.displayErrorMessage(error!.localizedDescription)
            }
        }
    }
    
    func displayErrorMessage(_ errorMessage:String){
        let alertController = UIAlertController(title:"Error",message:errorMessage,
                                                preferredStyle:UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"Dismiss",style:
            UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController,animated: true,completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
