//
//  SampleTableView.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 26/06/24.
//

import Foundation
import UIKit

//class SampleTableView: ViewController, CustomTableViewDataSource, CustomTableViewDelegate {
//    func numberOfItems(in customTableView: CustomTableView) -> Int {
//        
//    }
//    
//    func customTableView(_ customTableView: CustomTableView, itemForRowAt index: Int) -> UIView {
//        
//    }
//    
//    func customTableView(_ customTableView: CustomTableView, didSelectItemAt index: Int) {
//        print(index)
//    }
//    
//    func customTableView(_ customTableView: CustomTableView, didDeleteItemAt index: Int) {
//        print("deleted ")
//    }
//    
//    func customTableView(_ customTableView: CustomTableView) -> Int {
//        items.count
//    }
//    
//    func customTableView(_ customTableView: CustomTableView, cellForRowAt index: Int) -> String {
//        
//        return items[index]
//    }
//    
//    
//    var tableView: CustomTableView!
//    var items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView = CustomTableView()
//        
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        view.addSubview(tableView)
//        
//        
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        tableView.reloadData()
//        
//    }
//    
//    
//}
