//
//  employee_appUITests.swift
//  employee-appUITests
//
//  Created by Tamilselvi Seerangaraj on 04/06/24.
//

import XCTest
@testable import employee_app

final class employee_appUITests: XCTestCase {
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
    
    func testHomePage() {
        if (!UIComponents.homeView.exists) {
            signIn()
        }
        XCTAssertTrue(UIComponents.homeView.exists)
        if (UIComponents.employeeTV.exists) {
            let cell = UIComponents.employeeTV.cells.element(boundBy: 0)
            cell.swipeLeft()
            XCTAssertTrue(cell.buttons["Delete"].exists)
            cell.buttons["Delete"].tap()
            XCTAssertFalse(cell.buttons["Delete"].exists)
            
        }
        let name = UIComponents.username
        let email = UIComponents.email
        let logout = "Logout"
        let delUser = "Delete User"
        XCTAssertTrue(UIComponents.menuBar.exists)
        UIComponents.menuBar.tap()
        
        XCTAssertTrue(UIComponents.menuTV.exists)
        XCTAssertEqual(UIComponents.menuTV.cells.element(boundBy: 0).staticTexts.firstMatch.label, name)
        XCTAssertEqual(UIComponents.menuTV.cells.element(boundBy: 1).staticTexts.firstMatch.label, email)
        XCTAssertEqual(UIComponents.menuTV.cells.element(boundBy: 2).staticTexts.firstMatch.label, logout)
        XCTAssertEqual(UIComponents.menuTV.cells.element(boundBy: 3).staticTexts.firstMatch.label, delUser)
        UIComponents.menuBar.tap()
        //delete user record
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
