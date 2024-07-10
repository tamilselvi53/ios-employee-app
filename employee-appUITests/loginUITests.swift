//
//  loginUITests.swift
//  employee-appUITests
//
//  Created by Tamilselvi Seerangaraj on 19/06/24.
//

import XCTest

final class loginUITests: XCTestCase {

    var app: XCUIApplication?
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app?.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testSignUpSuccess() {
        if (UIComponents.newUserButton.exists) {
            UIComponents.newUserButton.tap()
        }
        
        signUp(username: UIComponents.username, password: UIComponents.password, email: UIComponents.email)
        XCTAssertTrue(UIComponents.homeView.exists)
        
        //To delete current test_user record
        deleteUser()
    }
    
    func testSignInSuccess() {
        if (UIComponents.newUserButton.exists) {
            UIComponents.newUserButton.tap()
        }
        signUp(username: UIComponents.username, password: UIComponents.password, email: UIComponents.email)
        UIComponents.menuBar.tap()
        UIComponents.menuTV.cells.element(boundBy: 2).tap()
        if (UIComponents.signInUsernameField.exists) {
            UIComponents.signInUsernameField.tap()
            UIComponents.signInUsernameField.typeText(UIComponents.username)
        }
        if (UIComponents.signInPasswordField.exists) {
            UIComponents.signInPasswordField.tap()
            UIComponents.signInPasswordField.typeText(UIComponents.password)
            UIComponents.signInPasswordField.tap()
        }
        if (UIComponents.signInButton.exists) {
            // app?.keyboards.buttons["done"].tap()
            UIComponents.signInButton.tap()
        }
        sleep(5)
        XCTAssertTrue(UIComponents.homeView.exists)
        deleteUser()
    }
    
    func signIn() {
        if (UIComponents.newUserButton.exists) {
            UIComponents.newUserButton.tap()
        }
        signUp(username: UIComponents.username, password: UIComponents.password, email: UIComponents.email)
        if (UIComponents.signInUsernameField.exists) {
            UIComponents.signInUsernameField.tap()
            UIComponents.signInUsernameField.typeText(UIComponents.username)
        }
        if (UIComponents.signInPasswordField.exists) {
            UIComponents.signInPasswordField.tap()
            UIComponents.signInPasswordField.typeText(UIComponents.password)
        }
        if (UIComponents.signInButton.exists) {
            UIComponents.signInButton.tap()
        }
    }
    
    func deleteUser() {
        XCTAssertTrue(UIComponents.menuBar.exists)
        UIComponents.menuBar.tap()
        UIComponents.menuTV.cells.element(boundBy: 3).tap()
        XCTAssertTrue(UIComponents.newUserButton.exists)
    }
    
    func signUp(username: String, password: String, email: String) {
        if (UIComponents.signUpUsernameField.exists) {
            UIComponents.signUpUsernameField.tap()
            UIComponents.signUpUsernameField.typeText(UIComponents.username)
        }
        if (UIComponents.signUpEmailField.exists) {
            UIComponents.signUpEmailField.tap()
            UIComponents.signUpEmailField.typeText(UIComponents.email)
        }
        if (UIComponents.signUpPasswordField.exists) {
            UIComponents.signUpPasswordField.tap()
            UIComponents.signUpPasswordField.typeText(UIComponents.password)
            UIComponents.signUpUsernameField.tap()
        }
        if (UIComponents.signUpButton.exists) {
            UIComponents.signUpButton.tap()
        }
    }
}
