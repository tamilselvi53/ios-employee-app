//
//  AuthHeaderView.swift
//  login-page
//
//  Created by Tamilselvi Seerangaraj on 20/05/24.
//

import UIKit

class AuthHeaderView: UIView {
    
    // MARK: - Variables
    
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let scrollView = UIStackView()
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    private let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        iv.tintColor = .white
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "Title"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Title"
        return label
    }()
    
    // MARK: - Lifecycle
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.subtitleLabel.text = subTitle
        self.setupUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(stackView)
        self.stackView.addArrangedSubview(logoImageView)
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(subtitleLabel)
        stackView.axis = .vertical
        // stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            self.logoImageView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
//            self.logoImageView.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
            self.logoImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
            self.logoImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.50),
            
//            self.titleLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 15),
//            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            
//            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
//            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.subtitleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
            
        ])
    }

    // MARK: - Selectors
}
