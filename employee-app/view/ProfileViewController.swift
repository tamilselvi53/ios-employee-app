//
//  menuViewController.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 21/06/24.
//

import UIKit

protocol ProfileView {
    var homePresenter: MainPresenter? { get set }
    func updateMenu(with user: User)
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileView {
    var homePresenter: (any MainPresenter)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("inisde menuVC cell")
        let cell = UITableViewCell()
        cell.backgroundColor = .systemBackground
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem
        
        if (indexPath.row == 0) {
            let button: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle("Edit", for: .normal)
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            cell.contentView.addSubview(button)
            cell.contentView.bringSubviewToFront(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 30),
                button.widthAnchor.constraint(equalToConstant: 30),
                button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            button.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.row == 0) {
//            showPopup(index: indexPath.row)
//        }
        if (indexPath.row == menuItems.count - 2) {
            didTapLogout()
        }
        if (indexPath.row == menuItems.count - 1) {
            didTapDeleteUser()
        }
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        var index = sender.tag
        showPopup(index: index)
    }
    
    func showPopup(index: Int) {
        let alert = UIAlertController(title: "Edit Username", message: "Enter new username", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New username"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                self?.homePresenter?.editUsername(newName: newName, oldName: newName)
                self?.menuItems[0] = newName
                self?.menuTableView.reloadData()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    let menuView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        // view.accessibilityIdentifier = "menuView"
        return view
    }()
    var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemCyan
        tableView.frame = .zero
        return tableView
    }()
    var menuItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(menuView)
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "User Profile"
        menuView.addSubview(menuTableView)
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
        setup()
        self.homePresenter?.fetchUserDetails()
    }
    
    func setup() {
        menuView.backgroundColor = .systemBlue
        menuTableView.backgroundColor = .systemPink
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuView.topAnchor.constraint(equalTo: (view.safeAreaLayoutGuide.topAnchor)),
            menuView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            menuView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            menuTableView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            menuTableView.topAnchor.constraint(equalTo: menuView.topAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor)
        ])
    }
    
    func updateMenu(with user: User) {
        print("in menuVC")
        self.menuItems.append(user.userName)
        self.menuItems.append(user.emailId)
        self.menuItems.append("Logout")
        self.menuItems.append("Delete User")
        self.menuTableView.reloadData()
    }

    @objc private func didTapLogout() {
        let router = Router.start()
        let loginRouter = router.entry
        Interactor.defaults.set(nil, forKey: "loggedInUser")
        SceneDelegate.shared?.router = router
        SceneDelegate.shared?.window?.rootViewController = loginRouter!
    }
    
    @objc private func didTapDeleteUser() {
        Interactor.defaults.set(nil, forKey: "loggedInUser")
        homePresenter?.deleteUser()
    }

}
