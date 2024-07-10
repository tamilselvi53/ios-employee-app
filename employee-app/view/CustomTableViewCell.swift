//
//  CustomTableViewCell.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 01/07/24.
//

import Foundation


import Foundation
import UIKit

class CustomTableViewCell: UIView {
    let containerView = UIView()
    let deleteButton = UIButton(type: .system)
    let padding: CGFloat = 5
    var bgColor: UIColor = .systemBackground
    
    
    init(frame: CGRect, bgColor: UIColor) {
        super.init(frame: frame)
        backgroundColor = bgColor
        self.bgColor = bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createCell(with text: String, at index: Int, subtitle desc: String?) -> UIView {
        containerView.tag = index
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let itemView = UIView()
        itemView.backgroundColor = bgColor
        itemView.translatesAutoresizingMaskIntoConstraints = false
        itemView.tag = index
        
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: itemView.heightAnchor, multiplier: 0.7),
            label.topAnchor.constraint(equalTo: itemView.topAnchor),
            label.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant:  2 * padding)
        ])
        
        let subLabel = UILabel()
        subLabel.text = desc
        subLabel.font = UIFont.systemFont(ofSize: 13)
        subLabel.textAlignment = .center
        subLabel.textColor = .black
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(subLabel)
        
        NSLayoutConstraint.activate([
            subLabel.heightAnchor.constraint(equalTo: itemView.heightAnchor, multiplier: 0.3),
            subLabel.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: -padding),
            subLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor, constant: padding),
            subLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 2 * padding),
        ])
        
        containerView.addSubview(itemView)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        // deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        deleteButton.tag = index
        
        containerView.addSubview(deleteButton)
        let ctv = CustomTableView()
        ctv.addTapGesture(to: deleteButton)
        NSLayoutConstraint.activate([
            itemView.heightAnchor.constraint(equalToConstant: 55),
            itemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            itemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            itemView.topAnchor.constraint(equalTo: containerView.topAnchor),
            itemView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -80),
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        return containerView
    }
}
