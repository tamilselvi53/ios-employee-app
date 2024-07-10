//
//  EmployeeDetailsAppTests.swift
//  EmployeeDetailsAppTests
//
//  Created by Tamilselvi Seerangaraj on 11/06/24.
//

import XCTest
@testable import employee_app

class ZSMockHomePresenter: MainPresenter {
    var homeExpectationDict: Dictionary<homeExpectationMethods, XCTestExpectation> = [:]
    var homeView: (any HomeView)?
    
    var homeInteractor: (any MainInteractor)?
    
    var homeRouter: HomeRouter?
    
    init() {
        homeExpectationDict[homeExpectationMethods.interactorDidFetchEmployees] = XCTestExpectation(description: "Loading employee details")
        homeExpectationDict[homeExpectationMethods.interactorDidFetchUserDetails] = XCTestExpectation(description: "Invalid api, returns user details")
    }
    func fetchEmployeeDetails(from api: String) {
        
    }
    
    func deleteUser() {
        
    }
    
    func fetchUserDetails() {
        
    }
    
    func interactorDidFetchEmployees(with employees: [Employee]?) {
        homeExpectationDict[homeExpectationMethods.interactorDidFetchEmployees]?.fulfill()
    }
    
    func interactorDidFetchUserDetails(with user: User) {
        homeExpectationDict[homeExpectationMethods.interactorDidFetchUserDetails]?.fulfill()
    }
    
    func notifyDeletion() {
        
    }
}

enum homeExpectationMethods {
    case interactorDidFetchEmployees, interactorDidFetchUserDetails
}

final class EmployeeDetailsAppTests: XCTestCase {
    
    var interactor: HomeInteractor?
    var presenter: ZSMockHomePresenter?
    
    override func setUpWithError() throws {
        var user = User(userName: DummyUser.username, emailId: DummyUser.email, password: DummyUser.password)
        self.interactor = HomeInteractor(with: user)
        presenter = ZSMockHomePresenter()
        self.interactor?.homePresenter = presenter
    }

    override func tearDownWithError() throws {
        interactor = nil
        presenter = nil
    }
    
    func testValidEmployeeAPI() {
        let dummyUser = User(userName: DummyUser.username, emailId: DummyUser.email, password: DummyUser.password)
        let api = "https://dummy.restapiexample.com/api/v1/employees"
        var fetchedEmployees = 0
        
        let result: () = HomeInteractor(with: dummyUser).fetchEmployeeDetails(from: api, completionHandler: { (employees: [Employee]) -> Void in
            fetchedEmployees = employees.count
            if (employees.count > 0) {
                self.interactor?.homePresenter?.interactorDidFetchEmployees(with: employees)
            }
        })
        let employees = 24
        if let exp = presenter!.homeExpectationDict[homeExpectationMethods.interactorDidFetchEmployees] {
            wait(for: [exp], timeout: 10)
        } else {
            XCTFail("Expectation is nil")
        }
    }
    
    func testInValidEmployeeAPI() {
        let dummyUser = User(userName: DummyUser.username, emailId: DummyUser.email, password: DummyUser.password)
        let api = "https://dummy.restapiexample.com/api/v1/employee"
        var fetchedEmployees = 0
        let result: () = HomeInteractor(with: dummyUser).fetchEmployeeDetails(from: api, completionHandler: { (employees: [Employee]) -> Void in
            fetchedEmployees = employees.count
            
            //exceptation doesn't get satisfied for wrong api, thus test passes
            if (employees.count == 0) {
                self.interactor?.homePresenter?.interactorDidFetchUserDetails(with: dummyUser)
            }
        })
        let employees = 24
        let exp = presenter!.homeExpectationDict[homeExpectationMethods.interactorDidFetchUserDetails]
        if let exp = exp {
            wait(for: [exp], timeout: 5)
        } else {
            XCTFail("Expectation is nil")
        }
        XCTAssertNotEqual(employees, fetchedEmployees)
    }
    
    func testInvalidParseEmployee() {
        let dummyUser = User(userName: DummyUser.username, emailId: DummyUser.email, password: DummyUser.password)
        let string = "hello"
        let result = HomeInteractor(with: dummyUser).parseEmployee(employeeJSON: string.data(using: .utf8)!)
        XCTAssertNil(result)
    }
}
