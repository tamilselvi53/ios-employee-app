//
//  interactor.swift
//  login-page
//
//  Created by Tamilselvi Seerangaraj on 03/06/24.
//

import Foundation

protocol LoginInteractor {
    var presenter: LoginPresenter? { get set }
    func authenticateUser(username: String, password: String) -> Bool
    func createNewUser(username: String, emailId: String, password: String) -> Bool
    func deleteUserInDefaults(username: String)
    func editUsername(newName: String, oldName: String)}


class Interactor: LoginInteractor {
    var presenter: (any LoginPresenter)?
    static let defaults = UserDefaults.standard
    var user: User?
    
    func authenticateUser(username: String, password: String) -> Bool {
        if (Interactor.defaults.array(forKey: username) == nil) {
            self.presenter?.loginFailed()
            return false
        }
        let userData = Interactor.defaults.array(forKey: username)
        let storedPassword = userData?.last as! String
        //User not exist
        if (storedPassword.elementsEqual(password)) {
            let emailId = userData?.first as! String
            self.user = User(userName: username, emailId: emailId, password: password)
            let userArray = [user?.userName, user?.emailId, user?.password]
            self.presenter?.loginSuccess(with: user!)
            return true
        }
        self.presenter?.loginFailed()
        return false
    }
    
    func createNewUser(username: String, emailId: String, password: String) -> Bool {
        // Username unique
        print(username)
        print(Interactor.defaults.object(forKey: username) == nil)
        if (Interactor.defaults.object(forKey: username) != nil) {
            self.presenter?.registrationFailed(reason: "usernameExist")
            return false
        }
        //Password length - min(8)
        if !isPasswordValid(for: password) {
            // print(password)
            print(" Password Validation failed")
            self.presenter?.registrationFailed(reason: "passwordValidationFailed")
            return false
        }
        
        if !isValidEmail(for: emailId) {
            self.presenter?.registrationFailed(reason: "emailValidationFailed")
            return false
        }
        
        let credentials = [emailId, password]
        Interactor.defaults.set(credentials, forKey: username)
        Interactor.defaults.synchronize()
        self.user = User(userName: username, emailId: emailId, password: password)
        self.presenter?.registrationSuccess(with: user!)
        return true
    }
    
    func editUsername(newName: String, oldName: String) {
        var value = Interactor.defaults.value(forKey: user!.userName)
        Interactor.defaults.removeObject(forKey: user!.userName)
        Interactor.defaults.set(value, forKey: newName)
    }
    
    func isPasswordValid(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
//        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,32}$"
        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,20}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func deleteUserInDefaults(username: String) {
        Interactor.defaults.removeObject(forKey: username)
        print(Interactor.defaults.object(forKey: username) == nil)
        Interactor.defaults.synchronize()
    }
}
