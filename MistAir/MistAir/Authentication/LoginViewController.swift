//
//  LoginViewController.swift
//  MistAir
//
//  Created by Michelle Zhu on 2/11/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import UIKit
import Firebase

let loginGroup = DispatchGroup()
class LoginViewController: UIViewController, UITextFieldDelegate {

    //firebase authentication handler
    var handle: AuthStateDidChangeListenerHandle?
    
    //to store humidifier ID
    var humidifierID: String?
    
    //programatical UI
    //the welcome label
    let welcomeLabel: UILabel = {
        let welcome = UILabel()
        welcome.text = "Welcome to MistAir"
        welcome.textColor = UIColor.authTextYellow
        welcome.font = UIFont.boldSystemFont(ofSize: 28)
        welcome.adjustsFontSizeToFitWidth = true
        welcome.minimumScaleFactor = 0.5
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
        textfield.keyboardType = .default
        textfield.font = UIFont.systemFont(ofSize: 17)
        textfield.textColor = UIColor.customGrey
        textfield.contentVerticalAlignment = .center
        textfield.clearButtonMode = .whileEditing
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Enter humidifier ID"
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
        textfield.keyboardType = .emailAddress
        textfield.font = UIFont.systemFont(ofSize: 17)
        textfield.textColor = UIColor.customGrey
        textfield.contentVerticalAlignment = .center
        textfield.clearButtonMode = .whileEditing
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
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
        textfield.autocorrectionType = .no
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
        self.humidifierIDTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        //set background colour
        view.backgroundColor = UIColor.darkPurple

        //setup UI
        setupLoginBox()
        setupWelcomeLabel()
        setupHumidifierIDView()
        setupEmailView()
        setupPasswordView()
        setupLoginButton()
        setupRegisterButton()
        setupForgotPasswordButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //if already registered and logged in, go straight to main page
        handle = Auth.auth().addStateDidChangeListener({(auth,user)in
            if user != nil{
                let controller = BaseTabBarController()
                self.present(controller, animated: true, completion: nil)
            }
        })
        
        //if not yet logged in, check user default and fill in the humidifier identifier if any
        if let id = UserDefaults.standard.string(forKey: "Humidifier ID"){
            humidifierIDTextField.text = id
        }
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
        let height = 410
        if Device.IS_IPHONE_5{
            width = 260
        }
        loginView.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
    }
    
    
    //setup welcome label
    func setupWelcomeLabel(){
        self.view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.bottomAnchor.constraint(equalTo: self.loginView.topAnchor, constant: -8).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 0).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: 0).isActive = true
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
        loginButton.bottomAnchor.constraint(equalTo: self.loginView.bottomAnchor, constant: -24).isActive = true
        loginButton.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 16).isActive = true
        loginButton.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: -16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //add an action to the button
        loginButton.addTarget(self,action: #selector(loginAccount(_:)),for:.touchUpInside)
    }
    
    //setup register button
    func setupRegisterButton(){
        self.loginView.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -16).isActive = true
        registerButton.leftAnchor.constraint(equalTo: self.loginView.leftAnchor, constant: 16).isActive = true
        registerButton.rightAnchor.constraint(equalTo: self.loginView.rightAnchor, constant: -16).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //add an action to the button
        registerButton.addTarget(self,action: #selector(registerAccount(_:)),for:.touchUpInside)
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
        guard let email = emailTextField.text else{
            return
        }
        
        guard let password = passwordTextField.text else{
            return
        }
        
        //use email and password to register with firebae authentication service
        if isHumidifierIDEmpty(){
            humidifierIDEmptyErrorMessage()
        }
        else{
            checkHumidifierDevice()
        }
        
        loginGroup.notify(queue: .main){
            //register account
            self.registerFirebaseAccount(email, password)
            
            //save humidifier id to user defaults
            UserDefaults.standard.set(self.humidifierID, forKey: "Humidifier ID")
        }

    }
    
    private func isHumidifierIDEmpty() -> Bool{
        humidifierID = humidifierIDTextField.text
        if humidifierID != ""{
            return false
        }
        else{
            return true
        }
    }
    
    private func checkHumidifierDevice(){
        let databaseRef = Database.database().reference()
        let humidifierRef = databaseRef.child("humidifier")
        var foundTheHumidifier = false
        loginGroup.enter()
        humidifierRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let value = snapshot.value as? [String:NSDictionary] else{
                return
            }
            
            for key in value.keys{
                if key == self.humidifierID!{
                    foundTheHumidifier = true
                }
            }
            
            if foundTheHumidifier{
                loginGroup.leave()
            }else{
                self.humidifierIDValidationErrorMessage()
            }
        }
        )
    }
    
    fileprivate func registerFirebaseAccount(_ email: String, _ password: String) {
        Auth.auth().createUser(withEmail: email, password: password){(user,error) in
            if error != nil{
                let alertController = AlertMessage.displayErrorMessage(title: "Dismiss", message: error!.localizedDescription)
                self.present(alertController,animated: true,completion: nil)
            }
        }
    }
    
    fileprivate func loginFirebaseAccount(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password){(user,error) in
            if error != nil{
                let alertController = AlertMessage.displayErrorMessage(title: "Error", message: error!.localizedDescription)
                self.present(alertController,animated: true,completion: nil)
            }
        }
    }
    
    @objc func loginAccount(_ sender: Any) {
        guard let email = emailTextField.text else{
            return
        }
        guard let password = passwordTextField.text else{
            return
        }
        
        //use email and password to register with firebae authentication service
        if isHumidifierIDEmpty(){
            humidifierIDEmptyErrorMessage()
        }
        else{
            checkHumidifierDevice()
        }
        
        loginGroup.notify(queue: .main){
            //register account
            self.loginFirebaseAccount(email, password)
            
            //save humidifier id to user defaults
            //UserDefaults.standard.set(self.humidifierID, forKey: "Humidifier ID")
        }
    }
    
    private func humidifierIDEmptyErrorMessage(){
        let alertController = AlertMessage.displayErrorMessage(title: "Error", message: "Humidifier ID cannot be empty.")
        self.present(alertController,animated: true,completion: nil)
    }
    
    private func humidifierIDValidationErrorMessage(){
        let alertController = AlertMessage.displayErrorMessage(title: "Error", message: "This ID is not valid. Please find it on the bottom of your humidifier.")
        self.present(alertController,animated: true,completion: nil)
    }
    
}
