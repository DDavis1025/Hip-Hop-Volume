//
//  FollowButton.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/3/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class FollowButtonView: UIViewController, FollowDelegateProtocol {
    func sendFollowData(myData: Bool) {
        if myData {
            followButton.buttonState = .add
            print(".ADD")
        } else {
            followButton.buttonState = .delete
            print(".DELETE")
        }
    }
    
    
    var post:Post?
    var components = URLComponents()
    var imageView = UIImageView()
    var user:UILabel?
    var username:String?
    var userModel:GetUserByIDVM?
    var image:UIImageView?
    var userImageView:UIImageView?
    var child:SpinnerViewController?
    var imageLoader:DownloadImage?
    var userImage:String?
    var authorID:String?
    var user_id:String?
    var fromPushedVC:Bool = false
    var followButton = FollowerButton()
    var following: Set<String>? {
           didSet {
               print("following \(following)")
               
           }
       }

    var profile = SessionManager.shared.profile
    
 var id:String
 init(id: String) {
    self.id = id
    self.userModel = GetUserByIDVM(id: id)
    
    super.init(nibName: nil, bundle: nil)
    
  }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        print("albumVC View controller loaded")
        
            self.userModel?.usersDidChange = { [weak self] users in
            self?.user = UILabel()
            self?.user!.text = users[0].username ?? "undefined"
            self?.user_id = users[0].user_id
            self?.view.addSubview(self!.user!)
            if let picture = users[0].picture {
            self?.imageLoader?.downloadImage(urlString: picture)
                }
//            if let user_id = self?.user_id {
//            self?.setupButton(id: user_id)
//                }
                if let user_id = self?.user_id {
                    if let profile_sub = self?.profile?.sub {
                        if user_id != profile_sub {
                            if let self = self {
                            print("user_id != profile_sub")
                            self.view.addSubview(self.followButton)
                            self.setFollowButtonConstraints()
                            self.view.bringSubviewToFront(self.followButton)
                            self.setupButton(id: user_id)
                         }
                        } else {
                            print("user_id == profile_sub")
                        }
                    }
                }
                
                self?.view.isUserInteractionEnabled = true
                
        }
        
        if let profile_id = profile?.sub {
        getFollowing(id: profile_id)
        }
        
        addActionToFlwBtn()
        
        getUser()
    
        view.backgroundColor = UIColor.yellow
        
        view.bringSubviewToFront(followButton)


        print("navigation userandfollow \(navigationController)")

        
    }

    
    func getUser() {
        if let id = profile?.sub {
        print("profile?.sub id \(profile?.sub)")
        GetUsersById(id: id).getAllPosts {
            print("$0[0].username \($0[0].username)")
            if $0[0].username == nil {
                GETUser(id: id, path: "getUserInfo").getAllById {
                   self.username = $0[0].username
                }
            } else {
                self.username = $0[0].username
            }
          }
        }
    }
    
    
    func getFollowing(id: String) {
        GETUsersByFollowerId(id: id).getAllById {
            self.following = Set($0.map{String($0.user_id!)})
        }
    }
    
    
    
    func setupButton(id:String?) {
        if let followingUsers = self.following {
            if let id = id {
                if (followingUsers.contains(id)) {
                    followButton.buttonState = .delete
                } else {
                    followButton.buttonState = .add
                }
            }
        } 
    }
    
    @objc func setButtonAction() {
        
        if followButton.buttonState == .add {
            if let follower_id = profile?.sub, let follower_picture = profile?.picture?.absoluteString, let username = username {
                let follower = Follower(user_id: user_id!, follower_id: follower_id, follower_username: username, follower_picture: follower_picture )
              let postRequest = FollowerPostRequest(endpoint: "follower")
              
              postRequest.save(follower) { (result) in
                  switch result {
                  case .success(let follower):
                      print("The following follower has been added \(follower.follower_id) to user \(follower.user_id)")
                  case .failure(let error):
                      print("An error occurred \(error)")
                  }
              }
            }
              followButton.buttonState = .delete
        } else if followButton.buttonState == .delete {
          
            if let user_id = user_id, let follower_id = profile?.sub  {
                let deleteRequest = DLTFollowingRequest(user_id: user_id, follower_id: follower_id)
                
                deleteRequest.delete {(err) in
                    if let err = err {
                        print("Failed to delete", err)
                        return
                    }
                    print("Successfully deleted followed user from server")
                    
                }
             }
             followButton.buttonState = .add
        }
               
    }
    
    func addActionToFlwBtn() {
        followButton.addTarget(self, action: #selector(setButtonAction), for: .touchUpInside)
    }
    
    
    func setFollowButtonConstraints() {
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.sizeToFit()
        followButton.layer.cornerRadius = 5
        followButton.layer.borderWidth = 2
        let spacing: CGFloat = 8.0
        followButton.layer.borderColor = UIColor.black.cgColor
        followButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        followButton.bringSubviewToFront(followButton)
        
        followButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        followButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        followButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        followButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }

    

}



