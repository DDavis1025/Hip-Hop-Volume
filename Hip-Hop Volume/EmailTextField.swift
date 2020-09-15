//
//  EmailTextField.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/19/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

protocol EmailDelegateProtocol {
    func sendEmailToEditProfileVC(myData: Bool)
}


class EmailTextField: Toolbar, UITextFieldDelegate {
    
    var delegate: EmailDelegateProtocol? = nil
    var user_profile = SessionManager.shared.profile
    let emailTextField = UITextField()
    let emailLabel = UILabel()
    var save = UIButton()
    var emailWarning:UILabel?
    let updateUser = UpdateUserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEmailTextField()
        addEmailLabel()
        addEmailConstraints()
        addNavButtons()
        emailTaken()
        
        view.backgroundColor = UIColor.white
        
    }
    
    func addEmailLabel() {
        emailLabel.text = "Email:"
        self.view.addSubview(emailLabel)
        
    }
    
    
    func addEmailTextField() {
        
        emailTextField.placeholder = "Enter email"
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        emailTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        emailTextField.delegate = self
        self.view.addSubview(emailTextField)
        
    }
    
    
    func addEmailConstraints() {
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 5).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
        
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }
    
    func addNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneTapped))
    }
    
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        print("hello")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        updateEmail()
    }
    
    
    
    
    func updateEmail() {
        var emailIsValid = isValidEmail(emailTextField.text!)
        
        if emailTextField.text != "" {
            print("email text \(emailTextField.text)")
            emailIsValid = isValidEmail(emailTextField.text!)
            if emailIsValid == false {
               print("email is not valid")
               self.emailWarning?.text = "⚠ Enter a valid email address"
               self.emailWarning?.isHidden = false
            } else {
            let emailValidation = EmailValidation()
            emailValidation.getEmail(email: emailTextField.text!.lowercased()) {
                print("getEmail")
                 if $0.count > 0 {
                    print("email already taken \($0)")
                    self.emailWarning?.isHidden = false
                    self.emailWarning?.text = "⚠ This email is already taken"
                 } else {
                    print("email accepted \($0)")
                    self.emailWarning?.isHidden = true
                    print("dispatch leave2")
                    self.updateUser.updateUserInfo(parameters: ["email": self.emailTextField.text!], user_id: self.user_profile!.sub, completion: {
                        self.delegate?.sendEmailToEditProfileVC(myData: true)
                    })
                    print("dismissed")
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
         }
      }
        
    }
    
   

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            self.emailWarning?.isHidden = true
        }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func emailTaken() {
        emailWarning = UILabel()
        emailWarning?.text = "⚠ This email is already taken"
        emailWarning?.textColor = UIColor.red
        emailWarning?.isHidden = true
        view.addSubview(emailWarning!)
        emailWarningConstraints()
    }
    
    func emailWarningConstraints() {
        emailWarning?.translatesAutoresizingMaskIntoConstraints = false
        
        emailWarning?.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 7).isActive = true

        emailWarning?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        emailWarning?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    
    
    
    
}


