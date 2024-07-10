//
//  homeRouter.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 04/06/24.
//

import Foundation
import UIKit


class HomeRouter {
    static func start(with user: User) -> UITabBarController {
        let homeRouter = HomeRouter()
        var homeView: HomeView = HomeViewController()
        var profileView: ProfileView = ProfileViewController()
        var homePresenter: MainPresenter = HomePresenter()
        var homeInteractor: MainInteractor = HomeInteractor(with: user)
        var loginPresenter: LoginPresenter = Presenter()
        
        homeView.homePresenter = homePresenter
        homePresenter.homeView = homeView
        homePresenter.homeInteractor = homeInteractor
        homePresenter.homeRouter = homeRouter
        homeInteractor.homePresenter = homePresenter
        profileView.homePresenter = homePresenter
        homePresenter.profileView = profileView
        homePresenter.loginPresenter = (loginPresenter as! Presenter)
        let tabVC = HomeRouter.setHomeVC(user: user, homeView: homeView as! HomeViewController, profileView: profileView as! ProfileViewController)
        return tabVC
    }
    static func setHomeVC(user: User, homeView: HomeViewController, profileView: ProfileViewController) -> UITabBarController {
        let tabVC = UITabBarController()
        let homeVC = UINavigationController(rootViewController: homeView)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
        
        let profileVC = UINavigationController(rootViewController: profileView)
        // profileVC.navigationBar.backgroundColor = .systemGray
        profileVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: nil)
        
        tabVC.setViewControllers([homeVC, profileVC], animated: false)
        tabVC.modalPresentationStyle = .fullScreen
        if let encodedUser = try? JSONEncoder().encode(user) {
            Interactor.defaults.set(encodedUser, forKey: "loggedInUser")
        }
        return tabVC
    }
}
