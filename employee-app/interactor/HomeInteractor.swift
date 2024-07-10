//
//  HomeInteractor.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 05/06/24.
//

import Foundation

protocol MainInteractor {
    var homePresenter: MainPresenter? { get set }
    func fetchEmployeeDetails(from api: String, completionHandler: @escaping CompletionHandler)
    func fetchEmployee(at index: Int) -> Employee
    func getEmployeesCount() -> Int
    func deleteEmployee(at index: Int)
    func editUsername(newName: String, oldName: String)
    func sortEmployees()
    
    func fetchUserDetails()
    func deleteUserInDefaults()
}

class HomeInteractor: MainInteractor {
    let user: User
    var homePresenter: (any MainPresenter)?

    var employees: [Employee] = []    
    init(with user: User) {
        self.user = user
    }
    func fetchEmployeeDetails(from api: String, completionHandler: @escaping CompletionHandler) {
        if let url = URL(string: api) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                print(error)
                guard let data = data else {
                    completionHandler(self.employees)
                    return
                }
                if let jsonArray = self.parseEmployee(employeeJSON: data) {
                    for employee in jsonArray {
                        self.updateEmployee(employee: employee)
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(self.employees)
                }
            }
            task.resume()
        }
   }
    
    
    func parseEmployee(employeeJSON: Data) -> [[String: Any]]? {
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: employeeJSON, options: []) as? [String: Any]
            let values = jsonArray?["data"] as? [[String: Any]]
            return values
        } catch {
            print("Error converting json object to dictionary: \(error)")
        }
        return nil
    }
    
    func sortEmployees() {
        employees = employees.sorted { (employee1: Employee, employee2: Employee) -> Bool in
            return employee1.employeeName < employee2.employeeName
        }
    }
    
    func fetchEmployee(at index: Int) -> Employee {
        return employees[index]
    }
    
    func getEmployeesCount() -> Int {
        return employees.count
    }
    
    func deleteEmployee(at index: Int) {
        employees.remove(at: index)
    }
    
    func editUsername(newName: String, oldName: String) {
        var value = Interactor.defaults.value(forKey: user.userName)
        Interactor.defaults.set(value, forKey: newName)
        Interactor.defaults.removeObject(forKey: user.userName)
    }
    
    func updateEmployee(employee: Dictionary<String, Any>) {
        let employee = Employee(id: employee["id"] as! Int,
        employeeName: employee["employee_name"] as! String,
        employeeSalary: employee["employee_salary"] as! Int,
        employeeAge: employee["employee_age"] as! Int,
        profileImage: employee["profile_image"] as! String)
        employees.append(employee)
    }
    
    func fetchUserDetails() {
        self.homePresenter?.interactorDidFetchUserDetails(with: user)
    }
    
    func deleteUserInDefaults() {
        Interactor.defaults.removeObject(forKey: user.userName)
        print(Interactor.defaults.object(forKey: user.userName) == nil)
        Interactor.defaults.synchronize()
        homePresenter?.notifyDeletion()
    }
}
