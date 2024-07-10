//
//  RegisterView.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 04/06/24.
//

import Foundation
import UIKit

protocol RegisterView {
    var presenter: LoginPresenter? { get set }
    var router: LoginRouter? { get set }
    
}

class RegisterController: UIView {
    func authenticationFailed() {
        
    }
    
    var presenter: (any LoginPresenter)?
    
    var router: (any LoginRouter)?
    
    
    //UI Component
    let view: UIView = {
        let view = UIView()
        return view
    }()
    private let headerView = AuthHeaderView(title: "Sign Up", subTitle: "Sign Up to your Account")
    private let usernameField = CustomTextField(fieldType: .username)
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Already have an account, Sign In", hasBackground: false, fontSize: .med, identifier: "signIn")
    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big, identifier: "signUp")
    static let defaults = UserDefaults.standard
    
    func viewDidLoad() {
        self.setupUI()
        // Do any additional setup after loading the view.
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerView)
        self.view.addSubview(usernameField)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signUpButton)
        self.view.addSubview(signInButton)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 270),
            
            self.usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 22),
            self.usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.usernameField.heightAnchor.constraint(equalToConstant: 50),
            self.usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 50),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 50),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12),
            self.signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 50),
            self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 12),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 50),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    //Selectors
    @objc func didTapSignIn() {
        
//        let vc = LoginController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapSignUp() {
        let registered = validateRegistration()
        if registered {
//            self.navigationController?.navigationBar.isHidden = false
//            let vc = HomeController()
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func validateRegistration() -> Bool {
        guard let username = usernameField.text as String? else { return false}
        guard let emailId = emailField.text as String? else { return false }
        guard let password = passwordField.text as String? else { return false }
        // value check
        if (username.isEmpty || emailId.isEmpty || password.isEmpty) {
            self.showAlert(title: "Required", message: "These fields are mandatory for registration")
            return false
        }
        // Username unique
        if RegisterController.defaults.object(forKey: username) != nil {
//            AlertManager.showRegistrationUserNameErrorAlert(on: self)
            return false
        }
        
        //Password length - min(8)
        if password.count < 8 {
//            AlertManager.showPasswordLengthAlert(on: self)
            return false
        }
        
        let credentials = [emailId, password]
        RegisterController.defaults.set(credentials, forKey: username)
        RegisterController.defaults.synchronize()
        let alertController = UIAlertController(title: "Registration Success!", message: "Please Sign In to continue", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
//        present(alertController, animated: true)
        return true
    }
    
    func showAlert(on vc: UIViewController, title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // vc.present(alert, animated: true)
    }
}
