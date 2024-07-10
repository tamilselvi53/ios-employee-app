//
//  CustomTextField.swift
//  login-page
//
//  Created by Tamilselvi Seerangaraj on 20/05/24.
//

import UIKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case username
        case email
        case password
    }

    private let authFieldType: CustomTextFieldType
    weak var eyeButton: UIButton!
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        
        switch fieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email Address"
            self.textContentType = .emailAddress
            self.keyboardType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
            // imageName = self.isSecureTextEntry ? "eye_closed" : "eye_open"
            // self.eyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
            // self.addSubview(eyeButton!)
            // setPasswordVisibility()
        }
        
    }
    
//    func setPasswordVisibility() {
//        self.isSecureTextEntry.toggle()
//        let imageName = self.isSecureTextEntry ? "eye_closed" : "eye_open"
//        self.eyeButton.setImage(UIImage(named: "logo"), for: .normal)
//    }
    required init?(coder: NSCoder) {
        fatalError("TextField is not implemented")
    }

}
