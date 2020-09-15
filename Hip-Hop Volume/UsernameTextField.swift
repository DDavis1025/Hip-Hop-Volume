//
//  UsernameTextField.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/19/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

protocol MyDataSendingDelegateProtocol {
    func sendDataToEditProfileVC(myData: Bool)
}

class UsernameTextField: Toolbar, UITextFieldDelegate {
    
    var delegate: MyDataSendingDelegateProtocol? = nil
    
    var user_profile = SessionManager.shared.profile
    let userTextField =  UITextField()
    let userLabel = UILabel()
    var save = UIButton()
    let updateUser = UpdateUserInfo()
    var usernameWarning:UILabel?
    let editPF = EditPFStruct()
    let usernameNil:Bool? = false
    var isAuth0Username:Bool?
    var usernameExists:Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserTextField()
        usernameTaken()
        addUserLabel()
        addUserConstraints()
        addNavButtons()
        
        checkForAuth0Username()
        
        view.backgroundColor = UIColor.white
        
        
        
        
    }
    
    func checkForAuth0Username() {
        if let id = user_profile?.sub {
            GetUsersById(id: id).getAllPosts {
                if $0[0].username == nil {
                    self.isAuth0Username = false
                    GETUser(id: id, path: "getUserInfo").getAllById {
                      if $0.count > 0 {
                        self.usernameExists = true
                  }
                }
            }
          }
       }
    }
        
        
        
        func addUserLabel() {
            userLabel.text = "Username:"
            self.view.addSubview(userLabel)
            
        }
        
        
        func addUserTextField() {
            
            userTextField.placeholder = "Enter username"
            userTextField.font = UIFont.systemFont(ofSize: 15)
            userTextField.borderStyle = UITextField.BorderStyle.roundedRect
            userTextField.autocorrectionType = UITextAutocorrectionType.no
            userTextField.keyboardType = UIKeyboardType.default
            userTextField.returnKeyType = UIReturnKeyType.done
            userTextField.clearButtonMode = UITextField.ViewMode.whileEditing
            userTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            userTextField.delegate = self
            self.view.addSubview(userTextField)
            
            
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = 20
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    
        func addUserConstraints() {
            userTextField.translatesAutoresizingMaskIntoConstraints = false
            
            userTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            userTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            userTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            userTextField.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 5).isActive = true
            
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            
            userLabel.translatesAutoresizingMaskIntoConstraints = false
            
            userLabel.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor).isActive = true
            
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        }
        
        
        func addNavButtons() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneTapped))
        }
        
        
        @objc func cancelTapped(sender: UIBarButtonItem) {
            if let username = self.userTextField.text, let isAuth0Username = isAuth0Username {
                if username == "" && isAuth0Username == false && usernameExists == false {
                    emptyUsernameAlert()
                    tabBarController?.tabBar.isUserInteractionEnabled = false
                    navigationController?.toolbar.isUserInteractionEnabled = false
                } else {
                  navigationController?.popViewController(animated: true)
                  tabBarController?.tabBar.isUserInteractionEnabled = true
                  navigationController?.toolbar.isUserInteractionEnabled = true
                }
            }
        }
        
        @objc func doneTapped(sender: UIBarButtonItem) {
            if let username = self.userTextField.text, let isAuth0Username = isAuth0Username {
                if username == "" && isAuth0Username == false && usernameExists == false {
                    emptyUsernameAlert()
                    tabBarController?.tabBar.isUserInteractionEnabled = false
                    navigationController?.toolbar.isUserInteractionEnabled = false
                } else {
                  updateUsername()
                  tabBarController?.tabBar.isUserInteractionEnabled = true
                  navigationController?.toolbar.isUserInteractionEnabled = true
                }
            }
        }
    
    func emptyUsernameAlert() {
    let alert = UIAlertController(title: "Hello", message: "Please Enter a Username", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
            self.present(alert, animated: true, completion: nil)
    }
        
        
        func updateUsername() {
            if userTextField.text != "" {
                let usernameValidation = UsernameValidation()
                usernameValidation.getUsername(username: userTextField.text!) {
                    if $0.count > 0 {
                        self.usernameWarning?.isHidden = false
                    } else {
                       GETUserName(username: self.userTextField.text!, path: "getUsername").getAllById {
                             if $0.count > 0 {
                                 self.usernameWarning?.isHidden = false
                             } else {
                       
                        self.usernameWarning?.isHidden = true
                        if self.isAuth0Username != false {
                        self.updateUser.updateUserInfo(parameters: ["username": self.userTextField.text!], user_id: self.user_profile!.sub) {
                            print("done")
                            self.delegate?.sendDataToEditProfileVC(myData: true)
                        }
                        self.navigationController?.popViewController(animated: true)
                        } else {
                            self.updateUsernamePostgre()
                            self.delegate?.sendDataToEditProfileVC(myData: true)
                            self.navigationController?.popViewController(animated: true)
                         }
                        }
                      }
                    }
                }
            }
        }
    
        func updateUsernamePostgre() {
            if let id = user_profile?.sub, let username = self.userTextField.text {
    
            let userInfo = UsersModel2(username: username, user_id: id)
                       
                       let postRequest = UpdateUser(endpoint: "updateUserInfo")
                       postRequest.save(userInfo) { (result) in
                           switch result {
                           case .success(let comment):
                             print("you have successfully saved a username")
                           case .failure(let error):
                               print("An error occurred: \(error)")
                           }
                       }
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == userTextField {
                self.usernameWarning?.isHidden = true
            }
        }
        
        func usernameTaken() {
            usernameWarning = UILabel()
            usernameWarning?.text = "⚠ This username is already taken"
            usernameWarning?.textColor = UIColor.red
            usernameWarning?.isHidden = true
            view.addSubview(usernameWarning!)
            usernameWarningConstraints()
        }
        
        func usernameWarningConstraints() {
            usernameWarning?.translatesAutoresizingMaskIntoConstraints = false
            
            usernameWarning?.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 7).isActive = true
            
            usernameWarning?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            usernameWarning?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        }
        
        
        
        
}


