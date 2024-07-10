//
//  LoginAppTests.swift
//  EmployeeDetailsAppTests
//
//  Created by Tamilselvi Seerangaraj on 17/06/24.
//

import XCTest

class ZSMockLoginPresenter: LoginPresenter {
    var loginView: (any LoginView)?
    
    var homeView: (any HomeView)?
    
    var interactor: (any AnyInteractor)?
    
    var router: (any AnyRouter)?
    
    var loginExceptationDict: Dictionary<loginExpectationMethods, XCTestExpectation> = [:]
    
    init() {
        loginExceptationDict[loginExpectationMethods.loginSuccess] = XCTestExpectation(description: "Login Success")
        loginExceptationDict[loginExpectationMethods.loginFailed] = XCTestExpectation(description: "Login Failed")
        loginExceptationDict[loginExpectationMethods.registrationSuccess] = XCTestExpectation(description: "Registration Success")
        loginExceptationDict[loginExpectationMethods.registratinFailed] = XCTestExpectation(description: "Registration Failed")
    }
    
    func authenticateUser(username: String, password: String) -> Bool {
        return false
    }
    
    func createNewUser(username: String, emailId: String, password: String) {
        
    }
    
    func loginFailed() {
        loginExceptationDict[loginExpectationMethods.loginFailed]?.fulfill()
    }
    
    func loginSuccess(with user: User) {
        loginExceptationDict[loginExpectationMethods.loginSuccess]?.fulfill()
    }
    
    func registrationSuccess(with user: User) {
        loginExceptationDict[loginExpectationMethods.registrationSuccess]?.fulfill()
    }
    
    func registrationFailed(reason: String) {
        loginExceptationDict[loginExpectationMethods.registratinFailed]?.fulfill()
    }
}

enum loginExpectationMethods {
    case loginSuccess, loginFailed, registrationSuccess, registratinFailed
}

final class LoginAppTests: XCTestCase {

    var interactor: Interactor?
    var user: User?
    var presenter: ZSMockLoginPresenter?
    override func setUpWithError() throws {
        self.interactor = Interactor()
        self.user = User(userName: DummyUser.username, emailId: DummyUser.email, password: DummyUser.password)
        presenter = ZSMockLoginPresenter()
//        interactor?.presenter = ZSMockLoginPresenter(dict: loginExceptationDict!)
        interactor?.presenter = presenter
    }

    override func tearDownWithError() throws {
        interactor = nil
        presenter = nil
    }
    
    func testValidSignInRequest() {
        //arrange
        var loginResult: Bool
        
        //act
        signUp(username: DummyUser.username, password: DummyUser.password, email: DummyUser.email)
        loginResult = interactor!.authenticateUser(username: DummyUser.username, password: DummyUser.password)
        print(loginResult)
        //assert
        XCTAssertTrue(loginResult)
        deleteUser(username: DummyUser.username)
        interactor?.presenter?.loginSuccess(with: user!)
        if let exp = presenter!.loginExceptationDict[loginExpectationMethods.loginSuccess] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    func testInValidUsernameSignInRequest() {
        //arrange
        let username = "jenny"
        var loginResult: Bool
        
        //act
        loginResult = interactor!.authenticateUser(username: username, password: DummyUser.password)
        print(loginResult)
        //assert
        XCTAssertFalse(loginResult)
        interactor?.presenter?.loginFailed()
        if let exp = presenter!.loginExceptationDict[loginExpectationMethods.loginFailed] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    func testInValidPasswordSignInRequest() {
        //arrange
        let password = "1234567"
        var loginResult: Bool
        
        //act
        loginResult = interactor!.authenticateUser(username: DummyUser.username, password: password)
        print(loginResult)
        //assert
        XCTAssertFalse(loginResult)
        interactor?.presenter?.loginFailed()
        if let exp = presenter!.loginExceptationDict[loginExpectationMethods.loginFailed] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    func testValidSignUpRequest() {
        //arrange
        var loginResult: Bool
        
        //act
        loginResult = interactor!.createNewUser(username: DummyUser.username, emailId: DummyUser.email, password: DummyUser.password)
        print(loginResult)
        
        //assert
        XCTAssertTrue(loginResult)
        deleteUser(username: DummyUser.username)
        interactor?.presenter?.registrationSuccess(with: user!)
        if let exp = presenter?.loginExceptationDict[loginExpectationMethods.registrationSuccess] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    func testUsernameInValidSignUpRequest() {
        //arrange
        var loginResult: Bool
        
        //act
        signUp(username: DummyUser.username, password: DummyUser.password, email: DummyUser.email)
        loginResult = interactor!.createNewUser(username: DummyUser.username, emailId: DummyUser.email, password: DummyUser.password)
        print(loginResult)
        //assert
        XCTAssertFalse(loginResult)
        interactor?.presenter?.registrationFailed(reason: "UsernameInvalid")
        if let exp = presenter!.loginExceptationDict[loginExpectationMethods.registratinFailed] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    func testPasswordInValidSignUpRequest() {
        //arrange
        let password = "          "

        var loginResult: Bool
        
        //act
        loginResult = interactor!.createNewUser(username: DummyUser.username, emailId: DummyUser.email, password: password)
        print(loginResult)
        //assert
        XCTAssertFalse(loginResult)
        interactor?.presenter?.registrationFailed(reason: "PasswordInvalid")
        if let exp = presenter!.loginExceptationDict[loginExpectationMethods.registratinFailed] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    func testPasswordLengthInValidSignUpRequest() {
        //arrange
        let password = "123"
        var loginResult: Bool
        
        //act
        loginResult = interactor!.createNewUser(username: DummyUser.username, emailId: DummyUser.email, password: password)
        print(loginResult)
        //assert
        XCTAssertFalse(loginResult)
        interactor?.presenter?.registrationFailed(reason: "PasswordLengthInvalid")
        if let exp = presenter!.loginExceptationDict[loginExpectationMethods.registratinFailed] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    
    //Email Not done
    func testEmailInValidSignUpRequest() {
        //arrange
        let email = "hey"
        var loginResult: Bool
        
        //act
        loginResult = interactor!.createNewUser(username: DummyUser.username, emailId: email, password: DummyUser.password)
        print(loginResult)
        
        //assert
        XCTAssertFalse(loginResult)
        interactor?.presenter?.registrationFailed(reason: "EmailInvalid")
        if let exp = presenter!.loginExceptationDict[loginExpectationMethods.registratinFailed] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    func deleteUser(username: String) {
        interactor?.deleteUserInDefaults(username: username)
    }
    
    func signUp(username: String, password: String, email: String) {
        interactor!.createNewUser(username: DummyUser.username, emailId: DummyUser.email, password: DummyUser.password)
    }
}
