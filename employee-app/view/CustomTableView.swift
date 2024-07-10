//
//  CustomTableView.swift
//  employee-app
//
//  Created by Tamilselvi Seerangaraj on 26/06/24.
//

import UIKit

protocol CustomTableViewDataSource: AnyObject {
    func numberOfItems(in customTableView: CustomTableView) -> Int
    func customTableView(_ customTableView: CustomTableView, itemForRowAt index: Int) -> UIView
}

protocol CustomTableViewDelegate: AnyObject {
    func customTableView(_ customTableView: CustomTableView, didSelectItemAt index: Int)
    func customTableView(_ customTableView: CustomTableView, didDeleteItemAt index: Int)
}

class CustomTableView: UIView {
    
    weak var dataSource: CustomTableViewDataSource?
    weak var delegate: CustomTableViewDelegate?
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        stackView = UIStackView()
        stackView.accessibilityScroll(UIAccessibilityScrollDirection.down)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 1.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Set up constraints for the scroll view
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func reloadData() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard let dataSource = dataSource else { return }
        
        let itemCount = dataSource.numberOfItems(in: self)
        for index in 0..<itemCount {
            let containerView = dataSource.customTableView(self, itemForRowAt: index)
            // Get data from vc and create cell in this class - old method
            // let containerView = createContainerView(with: itemText, at: index)
            // stackView.addArrangedSubview(containerView)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
            containerView.addGestureRecognizer(tapGesture)
            
            let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            leftSwipeGesture.direction = .left
            containerView.addGestureRecognizer(leftSwipeGesture)
                    
            let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            rightSwipeGesture.direction = .right
            containerView.addGestureRecognizer(rightSwipeGesture)
            
            stackView.addArrangedSubview(containerView)
            
            
            NSLayoutConstraint.activate([
                containerView.heightAnchor.constraint(equalToConstant: 55),
                containerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
                containerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: 80)
            ])
        }
    }
    
    func addTapGesture(to deleteButton: UIButton) {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func createContainerView(with text: String, at index: Int) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        let itemView = UIView()
        itemView.backgroundColor = .lightGray
        itemView.translatesAutoresizingMaskIntoConstraints = false
        itemView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        itemView.tag = index
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        itemView.addGestureRecognizer(tapGesture)
        
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        itemView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 16)
        ])
        
        containerView.addSubview(itemView)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        deleteButton.tag = index
        
        containerView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            itemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            itemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            itemView.topAnchor.constraint(equalTo: containerView.topAnchor),
            itemView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -80),
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipeGesture.direction = .left
        containerView.addGestureRecognizer(leftSwipeGesture)
                
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipeGesture.direction = .right
        containerView.addGestureRecognizer(rightSwipeGesture)
        
        return containerView
    }
    
    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        delegate?.customTableView(self, didSelectItemAt: view.tag)
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        delegate?.customTableView(self, didDeleteItemAt: index)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let containerView = gesture.view
            if gesture.direction == .left {
                UIView.animate(withDuration: 1.0, animations: {
                    containerView?.frame.origin.x = -80 })
                // containerView?.frame.origin.x = -80
            } else if gesture.direction == .right {
                UIView.animate(withDuration: 1.0, animations: {
                    containerView?.frame.origin.x = 0 })
                // containerView?.frame.origin.x = 0
            }
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
}
