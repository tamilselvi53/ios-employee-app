//
//  router.swift
//  login-page
//
//  Created by Tamilselvi Seerangaraj on 03/06/24.
//

import Foundation
import UIKit

typealias EntryPoint = LoginView & UIViewController

protocol LoginRouter {
    var entry: EntryPoint? { get set }
    static func start() -> LoginRouter
}

class Router: LoginRouter {
    var entry: EntryPoint?
    
    static func start() -> any LoginRouter {
        var router: LoginRouter = Router()
        var loginView: LoginView = LoginViewController()
        var presenter: LoginPresenter = Presenter()
        var interactor: LoginInteractor = Interactor()
        
        loginView.presenter = presenter
        presenter.loginView = loginView
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.entry = loginView as? EntryPoint
        return router
    }
}
