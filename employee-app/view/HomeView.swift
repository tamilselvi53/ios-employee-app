//
//  HomeView.swift
//  login-page
//
//  Created by Tamilselvi Seerangaraj on 03/06/24.
//

import Foundation
import UIKit

protocol HomeView {
    var homePresenter: MainPresenter? { get set }
    func update(with errorMessage: String)
    func update(with employee: [Employee])
    func updateMenu(with user: User)
    func userGotDeleted()
}
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    
    var homePresenter: (any MainPresenter)?
    
    // UI Component
    var employees: [Employee] = []
    var menuItems: [String] = []
    var tableView: CustomTableView!
    var menuTableView: UITableView!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let imageNames = ["image_1", "image_2", "image_3", "image_4", "image_5", "image_6"]
    var isTableView = true
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                #selector(handleRefresh),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    
    let menuView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.accessibilityIdentifier = "menuView"
        return view
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)  // Set insets
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    var buttonTapped = true
    
    var tabBarCnt = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "homeView"
        setupUI()
        self.homePresenter?.fetchEmployeeDetails(from: "https://dummy.restapiexample.com/api/v1/employees")

        // tableView.addSubview(refreshControl)
        // self.homePresenter?.fetchUserDetails()
        // fetchData()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        // tableView = UITableView(frame: view.bounds, style: .plain)
        tableView = CustomTableView()
        tableView.accessibilityIdentifier = "employeeTV"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tag = 1
        tableView.backgroundColor = .systemBackground
        // tableView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeeCell.identifier)
        menuTableView = UITableView(frame: menuView.bounds, style: .plain)
        menuTableView.backgroundColor = .systemBlue
        menuTableView.accessibilityIdentifier = "menuTV"
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.tag = 2
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.navigationItem.title = "Home Page"
        // self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "menu", style: .plain, target: self, action: #selector(dipTapHamburgerMenu))
        let viewButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2.fill"), style: .plain, target: self, action: #selector(didTapCollectionViewButton))
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.on.square"), style: .plain, target: self, action: #selector(didTapSortButton))
        self.navigationItem.rightBarButtonItems = [viewButton, sortButton]
        
        
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "menuBar"
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.accessibilityIdentifier = "spinner"
        
        self.view.addSubview(tableView)
        self.view.addSubview(menuView)
        self.menuView.addSubview(menuTableView)
        self.view.addSubview(activityIndicator)
        menuView.isHidden = true
        
        //add collectionview, register
        collectionView.register(EmployeeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        setupViews()
        
        tableView.isHidden = false
        collectionView.isHidden = true
    
    }
    func setupViews() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // self.menuView.frame.origin.x = self.view.frame.width
//        tabBarCnt.tabBar.tintColor = UIColor.black
//        self.view.addSubview(tabBarCnt.view)
        
        NSLayoutConstraint.activate([
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuView.topAnchor.constraint(equalTo: (view.safeAreaLayoutGuide.topAnchor)),
            menuView.heightAnchor.constraint(equalTo: view.heightAnchor),
            menuView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            menuTableView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            menuTableView.topAnchor.constraint(equalTo: menuView.topAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func createTabBarController() {
           let tabBarCnt = UITabBarController()
           tabBarCnt.tabBar.tintColor = UIColor.black

           let firstVc = LoginViewController()
           firstVc.title = "First"
           firstVc.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "HomeTab"), tag: 0)
           let secondVc = HomeViewController()
           secondVc.title = "Second"
           secondVc.tabBarItem = UITabBarItem.init(title: "Location", image: UIImage(named: "Location"), tag: 0)

           tabBarCnt.viewControllers = [firstVc, secondVc]
           
           self.view.addSubview(tabBarCnt.view)
       }
        
    @objc private func dipTapHamburgerMenu() {
        if buttonTapped {
            menuView.isHidden = false
            view.bringSubviewToFront(menuView)
            let finalPosition = CGRect(x: 0, y: 0, width: 20, height: 10)
//            UIView.animate(withDuration: 0.8, // Duration of the animation
//                                   delay: 0.0, // Delay before the animation starts
//                           options: [.curveEaseInOut], // Animation options
//                                   animations: {
//                        self.menuView.frame = finalPosition
//                    }, completion: nil)
            UIView.animate(withDuration: 1.0, animations: {
                self.menuView.frame.origin.x = self.view.frame.width * 0.6})
            buttonTapped.toggle()
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.menuView.frame.origin.x = self.view.frame.width})
            menuView.isHidden = true
            buttonTapped.toggle()
        }
    }
    @objc private func didTapCollectionViewButton() {
        isTableView.toggle()
        if isTableView {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2.fill"), style: .plain, target: self, action: #selector(didTapCollectionViewButton))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(didTapCollectionViewButton))
        }
        tableView.isHidden.toggle()
        collectionView.isHidden.toggle()
    }
    
    @objc private func didTapSortButton() {
        self.homePresenter?.sortEmployees()
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    @objc private func didTapLogout() {
        let router = Router.start()
        let loginRouter = router.entry
        SceneDelegate.shared?.router = router
        SceneDelegate.shared?.window?.rootViewController = loginRouter!
    }
    
    @objc private func didTapDeleteUser() {
        homePresenter?.deleteUser()
    }
}

extension HomeViewController: CustomTableViewDelegate, CustomTableViewDataSource {
    func numberOfItems(in customTableView: CustomTableView) -> Int {
        let count = homePresenter?.getEmployeesCount()
        return count!
        // return tableView.tag == 1 ? self.employees.count : self.menuItems.count
    }
    
    func customTableView(_ customTableView: CustomTableView, itemForRowAt index: Int) -> UIView {
        let employee = homePresenter?.fetchEmployee(at: index)
        let detailedText = "Id: \(employee!.id), Salary: \(employee!.employeeSalary), Age: \(employee!.employeeAge)"
        let cell = CustomTableViewCell(frame: .zero, bgColor: .systemGray3).createCell(with: employee!.employeeName, at: index, subtitle: detailedText)
        return cell
    }
    
    func customTableView(_ customTableView: CustomTableView, didSelectItemAt index: Int) {
        let newVC = ViewController()
        newVC.view.backgroundColor = .systemBackground
        let employee = homePresenter?.fetchEmployee(at: index)
        newVC.title = employee!.employeeName
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleRefresh() {
        tableView.reloadData()
    }
    func customTableView(_ customTableView: CustomTableView, didDeleteItemAt index: Int) {
        // employees.remove(at: index)
        homePresenter?.deleteEmployee(at: index)
        customTableView.reloadData()
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.deleteItems(at: [indexPath])
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = homePresenter?.getEmployeesCount()
        return count!
        // return employees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EmployeeCollectionViewCell
        cell.backgroundColor = .systemBackground
        cell.imageView.image = UIImage(named: "user")!
        cell.tag = indexPath.item
        let employee = homePresenter?.fetchEmployee(at: indexPath.row)

        cell.label.text = employee?.employeeName
        cell.label.textAlignment = .left
        
//        var viewMoreButton = UIButton(frame: CGRect(x:0, y:20, width:40,height:40))
//        viewMoreButton.setImage(UIImage(systemName: "ellipsis"))
//        viewMoreButton.addTarget(self, action: #selector(didTapViewMore()), for: UIControlEvents.touchUpInside)
        
        let imageName = imageNames[indexPath.item % imageNames.count]
        
        cell.imageView.image = nil
        loadImage(named: imageName) { image in
            DispatchQueue.main.async {
                if let currentIndexPath = collectionView.indexPath(for: cell), currentIndexPath == indexPath {
                    cell.imageView.image = image
                }
            }
        }
        
        var viewMoreButton = UIButton(type: .system)
        let image = UIImage(systemName: "ellipsis.circle")
        image?.withTintColor(UIColor.systemGray)
        viewMoreButton.setImage(image, for: .normal)
        viewMoreButton.imageView?.tintColor = UIColor.systemGray
        // viewMoreButton.setTitle("View More", for: .normal)
        // viewMoreButton.backgroundColor = .systemBackground
        // viewMoreButton.setTitleColor(.white, for: .normal)
        viewMoreButton.layer.cornerRadius = 5
        viewMoreButton.translatesAutoresizingMaskIntoConstraints = false
        viewMoreButton.tag = indexPath.item
        viewMoreButton.addTarget(self, action: #selector(viewMoreButtonTapped(_:)), for: .touchUpInside)
        cell.contentView.addSubview(viewMoreButton)
        
        NSLayoutConstraint.activate([
            viewMoreButton.leadingAnchor.constraint(equalTo: cell.label.trailingAnchor, constant: -30),
            viewMoreButton.bottomAnchor.constraint(equalTo: cell.label.bottomAnchor, constant: -8)
        ])

        return cell
    }
    
    func loadImage(named imageName: String, completion: @escaping (UIImage?) -> Void) {
            if let cachedImage = ImageCache.shared.object(forKey: imageName as NSString) {
                completion(cachedImage)
                return
            }
            
            if let image = UIImage(named: imageName) {
                ImageCache.shared.setObject(image, forKey: imageName as NSString)
                completion(image)
            } else {
                completion(nil)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 140)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Minimum spacing between rows
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newVC = ViewController()
        newVC.view.backgroundColor = .systemBackground
        let employee = homePresenter?.fetchEmployee(at: indexPath.row)
        newVC.title = employee!.employeeName
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func viewMoreButtonTapped(_ button: UIButton) {
        print(index)
        setupMoreView(button)
//        let cell = button.superview?.superview
//        var celldata = collectionView.indexPath(for: cell as! UICollectionViewCell)
//        var index = celldata?.item
        // var index = 0
//        homePresenter?.deleteEmployee(at: index!)
//        collectionView.deleteItems(at: [IndexPath(item: index!, section: 0)])
//        tableView.reloadData()
//        collectionView.reloadData()
    }
    
    func setupMoreView(_ button: UIButton) {
        let moreView = UIViewController()
        moreView.modalPresentationStyle = .popover
        moreView.view.backgroundColor = .systemBackground
        moreView.view.translatesAutoresizingMaskIntoConstraints = false
//        moreView.sheetPresentationController?.prefersGrabberVisible = true
        let height = view.frame.height * 0.5
        let width = view.frame.width
        moreView.preferredContentSize = CGSize(width: width, height: height)
        
        let deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.addTarget(self, action: #selector(didTapCVDeleteButton(_:)), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        moreView.view.addSubview(deleteButton)
        present(moreView, animated: true)
        
        NSLayoutConstraint.activate([
            // moreView.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
            
            deleteButton.leadingAnchor.constraint(equalTo: moreView.view.safeAreaLayoutGuide.leadingAnchor),
            deleteButton.topAnchor.constraint(equalTo: moreView.view.safeAreaLayoutGuide.topAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.widthAnchor.constraint(equalTo: moreView.view.safeAreaLayoutGuide.widthAnchor)
        ])
        let cell = button.superview?.superview
        let celldata = collectionView.indexPath(for: cell as! UICollectionViewCell)
        let index = celldata?.item
        deleteButton.tag = index!
        // var index = 0
        deleteButton.addTarget(self, action: #selector(didTapCVDeleteButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapCVDeleteButton(_ button: UIButton) {
        let index = button.tag
        homePresenter?.deleteEmployee(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        tableView.reloadData()
        collectionView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rows %d", menuItems.count)
        return tableView.tag == 1 ? self.employees.count : self.menuItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // print("indexPath")
        if (tableView.tag == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier, for: indexPath) as? EmployeeCell else {
                fatalError("It didn't dequeue a EmployeeCell in ViewController")
            }
            cell.backgroundColor = .systemBackground
            let employee = self.employees[indexPath.row]
            // print(employee.id)
            cell.configure(with: employee)
            
            cell.textLabel?.text = employee.employeeName
            cell.detailTextLabel?.text = "Id: \(employee.id), Salary: \(employee.employeeSalary), Age: \(employee.employeeAge)"
            return cell
        } else {
            let cell = menuTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .systemBackground
            let menuItem = menuItems[indexPath.row]
            cell.textLabel?.text = menuItem
            
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
            // button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath)
        if (tableView.tag == 1) {
            let newVC = ViewController()
            newVC.view.backgroundColor = .systemBackground
            newVC.title = employees[indexPath.row].employeeName
            navigationController?.pushViewController(newVC, animated: true)
        }
        if (tableView.tag == 2) {
            if (indexPath.row == 0) {
                // showPopup(index: indexPath.row)
            }
            if (indexPath.row == menuItems.count - 2) {
                didTapLogout()
            }
            if (indexPath.row == menuItems.count - 1) {
                didTapDeleteUser()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            print(indexPath.row)
            employees.remove(at: indexPath.row)
            // Then, delete the row from the table itself
            tableView.deleteRows(at: [indexPath], with: .fade)
            // collectionView.deleteItems(at: [indexPath])
            // tableView.reloadData()
        }
    }
    
}

extension HomeViewController: HomeView {
    func update(with errorMessage: String) {
        self.activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func update(with employee: [Employee]) {
//        self.employees = employee
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func updateMenu(with user: User) {
        print(user)
        self.menuItems.append(user.userName)
        self.menuItems.append(user.emailId)
        self.menuItems.append("Logout")
        self.menuItems.append("Delete User")
        self.menuTableView.reloadData()
    }
    
    func userGotDeleted() {
        let alertController = UIAlertController(title: "Success!", message: "User got deleted successfully", preferredStyle: .alert)

        present(alertController, animated: true, completion: nil)
//        sleep(15)
        didTapLogout()
    }
}
