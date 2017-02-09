//
//  LoginViewController.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/26/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Firebase
import Toucan

class LoginViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email address..."
        textField.backgroundColor = UIColor.white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter password..."
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var emailLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(redValue: 10, greenValue: 35, blueValue: 66, alpha: 1)
        button.addTarget(self, action: #selector(handleEmailLogin), for: .touchUpInside)
        button.setTitle("Login with email", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        return button
    }()
    
    let orTextLabel: UILabel = {
        let tf = UILabel()
        tf.attributedText = NSAttributedString(string: "OR", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy), NSForegroundColorAttributeName: UIColor.white])
        return tf
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(redValue: 10, greenValue: 35, blueValue: 66, alpha: 1)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(emailLoginButton)
        //view.addSubview(fbLoginButton)
        view.addSubview(orTextLabel)
        view.addSubview(registerButton)
        
        
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -250).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16 + 50).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16 / 2).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        emailLoginButton.translatesAutoresizingMaskIntoConstraints = false
        emailLoginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        emailLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        emailLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLoginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        /*fbLoginButton.delegate = self
         fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
         fbLoginButton.topAnchor.constraint(equalTo: emailLoginButton.bottomAnchor, constant: 50).isActive = true
         fbLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
         fbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         fbLoginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true*/
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.topAnchor.constraint(equalTo: emailLoginButton.bottomAnchor, constant: 50).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        orTextLabel.translatesAutoresizingMaskIntoConstraints = false
        orTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        orTextLabel.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor, constant: -50).isActive = true
        
        view.backgroundColor = UIColor(patternImage: Toucan(image: #imageLiteral(resourceName: "brunc")).resize(CGSize(width: view.frame.width, height: view.frame.height), fitMode: Toucan.Resize.FitMode.crop).image)
        
        if FIRAuth.auth()?.currentUser != nil {
            let tbc = TabBarController()
            tbc.selectedIndex = 1
            self.present(tbc, animated: true, completion: nil)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentPlace() {
        
        
        
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            let tbc = TabBarController()
            tbc.selectedIndex = 1
            self.present(tbc, animated: true, completion: nil)
            
            
        })
        
    }
    
    func handleEmailLogin() {
        if let email = emailTextField.text, let password = passwordTextField.text
        {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("Sign in error: \(error?.localizedDescription)")
                //display alert here etc...
                return
            }

            let tbc = TabBarController()
            tbc.selectedIndex = 1
            self.present(tbc, animated: true, completion: nil)
            
        })
        } else { print("not reading textfields") }
        
    } 
    
}

extension UIColor {
    static func rgb(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}





