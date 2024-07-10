//
//  view.swift
//  login-page
//
//  Created by Tamilselvi Seerangaraj on 03/06/24.
//

import Foundation
import UIKit

protocol LoginView {
    var presenter: LoginPresenter? { get set }
    var router: LoginRouter? { get set }
    func authenticationFailed()
    func registrationFailed(title: String, message: String)
}

class LoginViewController: UIViewController, LoginView {
    var router: (any LoginRouter)?
    var presenter: (any LoginPresenter)?
        
    func authenticationFailed() {
        showAlert(on: self, title: "Sign In Failed", message: "Please, Enter correct username & password")
    }

    let signIn: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your Account")
    private let usernameField = CustomTextField(fieldType: .username)
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big, identifier: "signIn")
    private let newUserButton = CustomButton(title: "New User? Create Account.", hasBackground: false, fontSize: .med, identifier: "newUser")
    private let forgotPasswordButton = CustomButton(title: "Forgot Password?", hasBackground: false, fontSize: .small, identifier: "forgotPassword")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSignUp()
        self.setupSignIn()
        
        // Do any additional setup after loading the view.
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        
        self.existingUserButton.addTarget(self, action: #selector(didTapExistingUser), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    private func setupSignIn() {
//        signUp.isHidden = true
//        signIn.isHidden = false
        self.view.addSubview(signIn)
        signIn.accessibilityIdentifier = "signInVC"
        self.setConstraints(for: "SignIn", on: signIn)
        
        usernameField.accessibilityIdentifier = "signInUsername"
        passwordField.accessibilityIdentifier = "signInPassword"
        signInButton.accessibilityIdentifier = "signInButton"
        newUserButton.accessibilityIdentifier = "newUserButton"
        
        NSLayoutConstraint.activate([
            signIn.topAnchor.constraint(equalTo: self.view.topAnchor),
            signIn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            signIn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            signIn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func setConstraints(for page: String, on view: UIStackView) {
        view.backgroundColor = .systemBackground
        if (page == "SignUp") {
            view.addArrangedSubview(signUpHeaderView)
            view.addArrangedSubview(signUpUsernameField)
            view.addArrangedSubview(signUpEmailField)
            view.addArrangedSubview(signUpPasswordField)
            view.addArrangedSubview(signUpButton)
            view.addArrangedSubview(existingUserButton)
            
            signUpHeaderView.translatesAutoresizingMaskIntoConstraints = false
            signUpUsernameField.translatesAutoresizingMaskIntoConstraints = false
            signUpEmailField.translatesAutoresizingMaskIntoConstraints = false
            signUpPasswordField.translatesAutoresizingMaskIntoConstraints = false
            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            existingUserButton.translatesAutoresizingMaskIntoConstraints = false
        } else {
            view.addArrangedSubview(headerView)
            view.addArrangedSubview(usernameField)
            view.addArrangedSubview(passwordField)
            view.addArrangedSubview(signInButton)
            view.addArrangedSubview(newUserButton)
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            usernameField.translatesAutoresizingMaskIntoConstraints = false
//            emailField.translatesAutoresizingMaskIntoConstraints = false
            passwordField.translatesAutoresizingMaskIntoConstraints = false
            signInButton.translatesAutoresizingMaskIntoConstraints = false
            newUserButton.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalSpacing
        
        view.translatesAutoresizingMaskIntoConstraints = false
        signIn.translatesAutoresizingMaskIntoConstraints = false
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        existingUserButton.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
//            signIn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            signIn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//            signIn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            signIn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//            
//            signUp.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            signUp.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//            signUp.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            signUp.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        if (page == "SignUp") {
            NSLayoutConstraint.activate([
                self.signUpHeaderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
                
                self.signUpUsernameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
                self.signUpUsernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

                self.signUpPasswordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
                self.signUpPasswordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.signUpEmailField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
                self.signUpEmailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.signUpButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
                self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

                self.existingUserButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
                self.existingUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),

                self.usernameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
                self.usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

                self.passwordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
                self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.signInButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
                self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

                self.newUserButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
                self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
            ])
        }
    }
    
    // Selector
    @objc private func didTapSignIn() -> Bool {
        return validateUser()
    }
    
    @objc func didTapNewUser() {
        signIn.isHidden = true
        signUp.isHidden = false
        // setupSignUp()
    }
    
    func validateUser() -> Bool {
        guard let username = usernameField.text as String? else { return false }
        guard let password = passwordField.text as String? else { return false }
    
        if (username.isEmpty || password.isEmpty) {
            showAlert(on: self, title: "Required", message: "These fields are mandatory for registration")
            return false
        }
        print(password)
        return ((self.presenter?.authenticateUser(username: username, password: password)) != nil)
    }
    
    
    // <----   Sign UP   ------>
    let signUp: UIStackView = {
        let view = UIStackView()
        view.accessibilityIdentifier = "signUpVC"
        return view
    }()
    
    private let signUpHeaderView = AuthHeaderView(title: "Sign Up", subTitle: "Sign Up to your Account")
    private let signUpUsernameField = CustomTextField(fieldType: .username)
    private let signUpEmailField = CustomTextField(fieldType: .email)
    private let signUpPasswordField = CustomTextField(fieldType: .password)
    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big, identifier: "signUp")
    private let existingUserButton = CustomButton(title: "Existing User? Sign In.", hasBackground: false, fontSize: .med, identifier: "existingUser")
    
    
    func setupSignUp() {
//        signIn.isHidden = true
//        signUp.isHidden = false
        self.view.addSubview(signUp)
        self.setConstraints(for: "SignUp", on: signUp)
        signUpUsernameField.accessibilityIdentifier = "signUpUsername"
        signUpPasswordField.accessibilityIdentifier = "signUpPassword"
        signUpEmailField.accessibilityIdentifier = "signUpEmail"
        signUpButton.accessibilityIdentifier = "signUpButton"
        existingUserButton.accessibilityIdentifier = "existingUserButton"
        
        NSLayoutConstraint.activate([
            signUp.topAnchor.constraint(equalTo: self.view.topAnchor),
            signUp.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            signUp.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            signUp.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    @objc func didTapExistingUser() {
        signUp.isHidden = true
        signIn.isHidden = false
        // setupSignIn()
    }
    @objc func didTapSignUp() {
        validateRegistration()
    }
    
    func validateRegistration() {
        guard let username = signUpUsernameField.text as String? else { return }
        guard let emailId = signUpEmailField.text as String? else { return }
        guard let password = signUpPasswordField.text as String? else { return }
        print(password)
        // value check
        if (username.isEmpty || emailId.isEmpty || password.isEmpty) {
            self.showAlert(on: self, title: "Required", message: "These fields are mandatory for registration")
            return
        }
        self.presenter?.createNewUser(username: username, emailId: emailId, password: password)
    }
    
    func registrationFailed(title: String, message: String) {
        showAlert(on: self, title: title, message: message)
    }
    
    func showAlert(on vc: UIViewController, title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "loginAlert"
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}

class SignIn: UIView {
}
