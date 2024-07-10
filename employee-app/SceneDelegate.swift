//
//  SceneDelegate.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 04/06/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: (any LoginRouter)?
    private(set) static var shared: SceneDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        router = Router.start()
        let initialVC = router?.entry
        //let nav = UINavigationController(rootViewController: initialVC)
        let user = getUser()
        if (user != nil) {
            window.rootViewController = HomeRouter.start(with: user!)
        } else {
            window.rootViewController = initialVC
        }
        self.window = window
        window.makeKeyAndVisible()
        Self.shared = self
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//                
//                let firstViewController = UIViewController()
//                firstViewController.view.backgroundColor = .white
//                firstViewController.title = "First"
//                firstViewController.navigationController?.navigationBar.backgroundColor = .brown
//        
//                let secondViewController = UIViewController()
//                secondViewController.view.backgroundColor = .lightGray
//                secondViewController.title = "Second"
//                secondViewController.navigationController?.navigationBar.backgroundColor = .brown
//
//                let navController1 = UINavigationController(rootViewController: firstViewController)
//                let navController2 = UINavigationController(rootViewController: secondViewController)
//                
//                let tabBarController = UITabBarController()
//                tabBarController.viewControllers = [navController1, navController2]
//                
//                window?.rootViewController = tabBarController
//                window?.makeKeyAndVisible()
    }
    
    func getUser() -> User? {
        let defaults = UserDefaults.standard
        if let savedUserData = defaults.object(forKey: "loggedInUser") as? Data {
            if let decodedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
                return decodedUser
            }
        }
        return nil
    }
}

