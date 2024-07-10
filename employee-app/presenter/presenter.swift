//
//  presenter.swift
//  login-page
//
//  Created by Tamilselvi Seerangaraj on 03/06/24.
//

import Foundation
import UIKit
protocol LoginPresenter {
    var loginView: LoginView? { get set }
    var homeView: HomeView? { get set }
    var interactor: LoginInteractor? { get set }
    var router: LoginRouter? { get set }
    
    // view to presenter
    func authenticateUser(username: String, password: String) -> Bool
    func createNewUser(username: String, emailId: String, password: String)
    func editUsername(newName: String, oldName: String)
    
    // presenter to view
    func loginFailed()
    func loginSuccess(with user: User)
    func registrationSuccess(with user: User)
    func registrationFailed(reason: String)
    // func registration
    
}

class Presenter: LoginPresenter {    
    var homeView: (any HomeView)?
    var loginView: (any LoginView)?
    var interactor: (any LoginInteractor)?
    var router: (any LoginRouter)?
    
    func createNewUser(username: String, emailId: String, password: String) {
        self.interactor?.createNewUser(username: username, emailId: emailId, password: password)
    }
    func authenticateUser(username: String, password: String) -> Bool {
        return ((self.interactor?.authenticateUser(username: username, password: password)) != nil)
    }
    
    func editUsername(newName: String, oldName: String) {
        interactor?.editUsername(newName: newName, oldName: oldName)
    }
    
    func loginSuccess(with user: User) {
        SceneDelegate.shared?.window?.rootViewController = HomeRouter.start(with: user)
    }
    func loginFailed() {
        self.loginView?.authenticationFailed()
    }
    func registrationSuccess(with user: User) {
//        let homeRouter = HomeRouter.start(with: user)
//        let tabVC = UITabBarController()
//        let homeVC = UINavigationController(rootViewController: homeRouter.first!)
//        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
//        
//        let profileVC = UINavigationController(rootViewController: homeRouter.last!)
//        // profileVC.navigationBar.backgroundColor = .systemGray
//        profileVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: nil)
//        
//        tabVC.setViewControllers([homeVC, profileVC], animated: false)
//        tabVC.modalPresentationStyle = .fullScreen
        SceneDelegate.shared?.window?.rootViewController = HomeRouter.start(with: user)
    }
    func registrationFailed(reason: String) {
        switch reason {
            case "usernameExist":
                self.loginView?.registrationFailed(title: "Registration Failed", message: "Username exist!")
            case "passwordValidationFailed":
                self.loginView?.registrationFailed(title: "Registration Failed", message: "Password should be minimum 8 characters")
            case "emailValidationFailed":
                self.loginView?.registrationFailed(title: "Registration Failed", message: "Please enter valid Email id")
            default:
                self.loginView?.registrationFailed(title: "Registration Failed", message: "Please, try again")
        }
    }
}
