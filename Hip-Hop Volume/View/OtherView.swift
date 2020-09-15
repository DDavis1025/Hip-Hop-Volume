
    import Foundation

    import UIKit
    import SwiftUI
    import AVFoundation
    import Auth0


//protocol MyProtocol: class {
//    func setResultOfBusinessLogic(valueSent: Bool?)
//}



class OtherView: Toolbar {
    

        let secondViewController = UIHostingController(rootView: ContentView())
    
    
        static var shared = OtherView()
        
//    
//        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
//            self.atVC.delegate = self
//            atVC.passingVar = "passedVar"
//            print("mainVC Del \(self.atVC.delegate)")
            print("This is a Git tutorial")
            
            view.backgroundColor = UIColor.white
//            view.bringSubviewToFront(globalAudioVC.view)
            view.isUserInteractionEnabled = true
            
           let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addTapped))
            
           let whoToFollow = UIBarButtonItem(title: "toFollow", style: .plain, target: self, action: #selector(toFollowTapped))

            navigationItem.leftBarButtonItem = profile
            navigationItem.rightBarButtonItem = whoToFollow
        
            
            secondViewController.view.isUserInteractionEnabled = true
            
            
            addSecondVC()
            auth0()

            
        }
    func auth0() {
        Auth0
        .webAuth()
        .scope("openid offline_access profile")
        .audience("https://dev-owihjaep.auth0.com/userinfo")
        .start {
            switch $0 {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let credentials):
                print(credentials.accessToken)
                if(!SessionManager.shared.store(credentials: credentials)) {
                    print("Failed to store credentials")
                } else {
                    SessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            guard error == nil else {
                                print("Failed to retrieve profile: \(String(describing: error))")
                                return
                        }
                      }
                    }
                }
            }
        }
    }
    
        
    
    
        func addSecondVC() {
            addChild(secondViewController)
            view.addSubview(secondViewController.view)
            secondViewController.didMove(toParent: self)
            setSecondChildVCConstraints()
        }

        
        func setSecondChildVCConstraints() {
        secondViewController.view.translatesAutoresizingMaskIntoConstraints = false
            secondViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            secondViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

            secondViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

            secondViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        }

//    override func willMove(toParent parent: UIViewController?){
//        super.willMove(toParent: OtherView())
//        if parent == nil {
//            self.navigationController?.isToolbarHidden = false
//            print("hello")
//        }
//    }
        
        
        
        
    @objc func addTapped() {
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func toFollowTapped() {
        let toFollowVC = WhoToFollowVC()
        self.navigationController?.pushViewController(toFollowVC, animated: true)
    }
       
        
        
    }




class AlbumView: Toolbar {
    

        let secondViewController = UIHostingController(rootView: ContentView())
    
    
        static var shared = OtherView()
        
//
//
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
//            self.atVC.delegate = self
//            atVC.passingVar = "passedVar"
//            print("mainVC Del \(self.atVC.delegate)")
            print("This is a Git tutorial")
            
            view.backgroundColor = UIColor.white
//            view.bringSubviewToFront(globalAudioVC.view)
            view.isUserInteractionEnabled = true
            
           let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addTapped))
            
           let whoToFollow = UIBarButtonItem(title: "toFollow", style: .plain, target: self, action: #selector(toFollowTapped))

            navigationItem.leftBarButtonItem = profile
            navigationItem.rightBarButtonItem = whoToFollow
        
            
            secondViewController.view.isUserInteractionEnabled = true
            
            
            addSecondVC()
            auth0()

            
        }
    func auth0() {
        Auth0
        .webAuth()
        .scope("openid offline_access profile")
        .audience("https://dev-owihjaep.auth0.com/userinfo")
        .start {
            switch $0 {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let credentials):
                print(credentials.accessToken)
                if(!SessionManager.shared.store(credentials: credentials)) {
                    print("Failed to store credentials")
                } else {
                    SessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            guard error == nil else {
                                print("Failed to retrieve profile: \(String(describing: error))")
                                return
                        }
                      }
                    }
                }
            }
        }
    }
    
        
    
    
        func addSecondVC() {
            addChild(secondViewController)
            view.addSubview(secondViewController.view)
            secondViewController.didMove(toParent: self)
            setSecondChildVCConstraints()
        }

        
        func setSecondChildVCConstraints() {
        secondViewController.view.translatesAutoresizingMaskIntoConstraints = false
            secondViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            secondViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

            secondViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

            secondViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        }

//    override func willMove(toParent parent: UIViewController?){
//        super.willMove(toParent: OtherView())
//        if parent == nil {
//            self.navigationController?.isToolbarHidden = false
//            print("hello")
//        }
//    }
        
        
        
        
    @objc func addTapped() {
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func toFollowTapped() {
        let toFollowVC = WhoToFollowVC()
        self.navigationController?.pushViewController(toFollowVC, animated: true)
    }
       
        
        
    }




    
    
    
   



