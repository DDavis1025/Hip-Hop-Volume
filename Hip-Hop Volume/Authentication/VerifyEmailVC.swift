//
//  VerifyEmailVC.swift
//  Hip-Hop Volume
//
//  Created by Dillon Davis on 11/20/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class VerifyEmailVC: Toolbar {
    var button = UIButton()
    var doneBtn = UIButton()
    var profile = SessionManager.shared.profile
    
    lazy var verifyEmailLabel:UILabel = {
        let label = UILabel()
        label.text = "Please verify your email before uploading content"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = true
        view.backgroundColor = UIColor.white
        view.addSubview(verifyEmailLabel)
        verifyEmailLabelConstraints()
        addResendBtn()
        addDoneBtn()
        edgesForExtendedLayout = []
    }
    
    @objc func goToPurchase() {
        let purchaseVC = IAPMasterViewController()
        navigationController?.pushViewController(purchaseVC, animated: true)
    }
    
    func verifyEmailLabelConstraints() {
           verifyEmailLabel.translatesAutoresizingMaskIntoConstraints = false
//           verifyEmailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           verifyEmailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
           verifyEmailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
           verifyEmailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
       }
    
    func addResendBtn() {
        button.setTitle("Resend", for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byClipping
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        button.backgroundColor = .clear
        let spacing: CGFloat = 8.0
        button.layer.borderColor = UIColor.blue.cgColor
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
     
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerXAnchor.constraint(equalTo: verifyEmailLabel.centerXAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: verifyEmailLabel.bottomAnchor, constant: 5).isActive = true
        
        button.isUserInteractionEnabled = true
        
        button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
        
        
    }
    
    func addDoneBtn() {
        doneBtn.setTitle("or Done", for: .normal)
        doneBtn.titleLabel?.numberOfLines = 1
        doneBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        doneBtn.titleLabel?.lineBreakMode = .byClipping
        doneBtn.setTitleColor(UIColor.blue, for: .normal)
        doneBtn.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        doneBtn.backgroundColor = .clear
        let spacing: CGFloat = 8.0
        doneBtn.layer.borderColor = UIColor.blue.cgColor
        doneBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
     
        view.addSubview(doneBtn)
        
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        
        doneBtn.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        
        doneBtn.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20).isActive = true
        
        doneBtn.isUserInteractionEnabled = true
        
        doneBtn.addTarget(self, action:#selector(doneBtnClicked), for: .touchUpInside)
        
        
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if let user_id = profile?.sub {
        let userInfo = Auth0User(user_id: user_id)
            
        print("userInfo \(userInfo)")
        
        let postRequest = EmailVerification(endpoint: "emailVerification")
        postRequest.save(userInfo) { (result) in
            switch result {
            case .success(let emailVerification):
            DispatchQueue.main.async {
              self.emailSentAlert()
            }
              print("you have successfully sent an email")
            case .failure(let error):
                print("An error occurred: \(error.rawValue)")
                DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert", message: error.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                      switch action.style{
                      case .default:
                            print("default")

                      case .cancel:
                            print("cancel")

                      case .destructive:
                            print("destructive")


                }}))
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
      }
    }
    
    @objc func doneBtnClicked(sender: UIButton) {
        if let user_id = profile?.sub {
        GetUsersById(id: user_id).getAllPosts {
            if let email_verified = $0[0].email_verified {
                if email_verified == true {
                    self.navigationController?.setViewControllers([MainTabBarController()], animated: true)
                    print(email_verified)
                } else {
                    DispatchQueue.main.async {
                    self.didntVerifyEmailAlert()
                    }
                }
            }
          }
        }
        
    }
    
    func didntVerifyEmailAlert() {
    let alert = UIAlertController(title: "Alert", message: "Your email is not verified", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
          switch action.style{
          case .default:
                print("default")

          case .cancel:
                print("cancel")

          case .destructive:
                print("destructive")


    }}))
    self.present(alert, animated: true, completion: nil)
    }
    
    
    func emailSentAlert() {
    let alert = UIAlertController(title: "Alert", message: "An email to verify your email has been sent", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
          switch action.style{
          case .default:
                print("default")

          case .cancel:
                print("cancel")

          case .destructive:
                print("destructive")


    }}))
    self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
}

