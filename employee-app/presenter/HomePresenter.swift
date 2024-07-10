//
//  HomePresenter.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 05/06/24.
//

import Foundation

protocol MainPresenter {
    var homeView: HomeView? { get set }
    var profileView: ProfileView? { get set }
    var homeInteractor: MainInteractor? { get set }
    var homeRouter: HomeRouter? { get set }
    var loginPresenter: Presenter? { get set }
    
    
    func fetchEmployeeDetails(from api: String)
    func fetchEmployee(at index: Int) -> Employee
    func getEmployeesCount() -> Int
    func deleteEmployee(at index: Int)
    func deleteUser()
    func fetchUserDetails()
    func sortEmployees()
    func editUsername(newName: String, oldName: String)
    func interactorDidFetchEmployees(with employees: [Employee]?)
    func interactorDidFetchUserDetails(with user: User)
    func notifyDeletion()
}
typealias CompletionHandler = (_ employees: [Employee]) -> Void

class HomePresenter: MainPresenter {

    
    var homeView: (any HomeView)?
    var profileView: (any ProfileView)?
    
    var homeInteractor: (any MainInteractor)?
    
    var homeRouter: HomeRouter?
    
    var loginPresenter: Presenter?
    
    
    func fetchEmployeeDetails(from api: String) {
        self.homeInteractor?.fetchEmployeeDetails(from: api, completionHandler: { (employees: [Employee]) -> Void in
            if (employees.count != 0) {
                self.homeView?.update(with: employees)
            } else {
                self.homeView?.update(with: "Couldn't fetch data, Try again!")
            }
        })
    }
//        self.homeInteractor?.fetchEmployeeDetails(from: api, @escaping (employees: [Employee]?) -> Void in
//        if (employees != nil) {
//            homeView?.update(with: employees!)
//        } else {
//            homeView?.update(with: "Couldn't fetch data, Try again!")
//        }
//    )
    
    func fetchEmployee(at index: Int) -> Employee {
        return (homeInteractor?.fetchEmployee(at: index))!
    }
    
    func getEmployeesCount() -> Int {
        return (homeInteractor?.getEmployeesCount())!
    }
    
    func deleteEmployee(at index: Int) {
        homeInteractor?.deleteEmployee(at: index)
    }
    
    func deleteUser() {
        homeInteractor?.deleteUserInDefaults()
    }
    
    func fetchUserDetails() {
        self.homeInteractor?.fetchUserDetails()
    }
    
    func sortEmployees() {
        self.homeInteractor?.sortEmployees()
    }
    
    func editUsername(newName: String, oldName: String) {
        self.homeInteractor?.editUsername(newName: newName, oldName: oldName)
    }
    
    func interactorDidFetchEmployees(with employees: [Employee]?) {
        if (employees != nil) {
            homeView?.update(with: employees!)
        } else {
            homeView?.update(with: "Couldn't fetch data, Try again!")
        }
    }
    
    func interactorDidFetchUserDetails(with user: User) {
        self.profileView?.updateMenu(with: user)
        // self.homeView?.updateMenu(with: user)
    }
    
    func notifyDeletion() {
        homeView?.userGotDeleted()
    }
}
