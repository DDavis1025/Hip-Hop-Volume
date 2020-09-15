//
//  ArtistProfileVC.swift
//  Test
//
//  Created by Dillon Davis on 4/16/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Auth0
import SwiftUI

protocol FollowDelegateProtocol {
    func sendFollowData(myData: Bool)
}

class ArtistProfileVC: Toolbar {
    
    var delegate: FollowDelegateProtocol? = nil

    var profile: UserInfo!
    var username:String?
    var isLoaded:Bool? = false
    var imageView:UIImageView!
    var author:[PostById]!
    var album:[Post]!
    var images:[UIImage]?
    var imageLoader:DownloadImage?
    var imageLoaded:Bool? = false
    var followUsersVC:FollowUsers?
    var usersWhoFollowVC:FollowUsers?
    let stackview = UIStackView()
    var button = UIButton()
    var followButton = FollowerButton()
    var refresher:UIRefreshControl?
    var label:UILabel? = nil
    var followingLabel = UILabel()
    var followingTitle = UILabel()
    var followsLabel = UILabel()
    var followsTitle = UILabel()
    var child:SpinnerViewController?
    var videoStruct = Video()
    var users = [UsersModel]() {
        didSet {
            DispatchQueue.main.async {
                print("usersdid \(self.users)")
                self.getUser {
                     self.userInfo()
                }
            }
        }
    }
    
    var usersFollowed = [UsersModel]() {
        didSet {
            DispatchQueue.main.async {
                self.followUsersVC = FollowUsers(users: self.usersFollowed)
            }
                
//                self.usersWhoFollowLabels()
                print("user flwed \(usersFollowed)")
//                followingLabel.text = String(usersFollowed.count)
                
//                followingTitle.isHidden = false
//                followingLabel.isHidden = false
//                self.followLabels()
        }
    }
    
    var usersWhoFollow = [UsersModel]() {
           didSet {
            DispatchQueue.main.async {
                self.usersWhoFollowVC = FollowUsers(users: self.usersWhoFollow)
            }
                   
//                    followsLabel.text = String(usersWhoFollow.count)
//            followsLabel.text = "11"
                    print("users who flw \(usersWhoFollow)")
//                    followsTitle.isHidden = false
//                    followsLabel.isHidden = false
//                    self.usersWhoFollowLabels()
//                    self.followLabels()
          }
       }
    var posts:Array<Any> = []
    var artistID:String?

    var following = [Following]() {
              didSet {
                   for followed in self.following {
                    GetUsersById(id: followed.user_id!).getAllPosts {
//                        self.followingLabel.text = String($0.count)
                        self.usersFollowed.append(contentsOf: $0)
//                        self.usersFollowed += $0
                        print("usersFollowed \(self.usersFollowed.count)")
                    }
                  }
                  
              }
          }
    var follows = [Follows]() {
        didSet {
            for follow in follows {
                GetUsersById(id: follow.follower_id!).getAllPosts {
//                  self.followsLabel.text = String($0.count)
                  self.usersWhoFollow.append(contentsOf: $0)
//                  self.usersWhoFollow += $0
                  print("usersFollowing \(self.usersWhoFollow.count)")
              }
            }
            
        }
    }
    
    var checkFollowing: Set<String>? {
        didSet {
            setupButton(id: artistID)
            
        }
    }
    var fromNowPlaying:Bool = false
    
    
    static var shared = ArtistProfileVC()
    
    
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        
        return component
    }()
    

        override func viewDidLoad() {
            super.viewDidLoad()
            profile = SessionManager.shared.profile

            print("fromNowPlaying \(fromNowPlaying)")
            
            addImagePH()
            addCollectionView()
            
                if let artistID = self.artistID {
                self.getArtist(id: artistID)
                self.getFollowers(id: artistID)
            }
            
            self.usersWhoFollowLabels()
            self.followLabels()
            
            self.view.addSubview(self.followButton)
            self.setFollowButtonConstraints()

            if let artistID = artistID {
             if artistID != profile.sub {
              getFollowing(id: profile.sub)
             }
            }
            
            addActionToFlwBtn()
            
            
            print("navigation artistPF \(navigationController)")
            
            view.backgroundColor = UIColor.white
            
            if fromNowPlaying {
                navigationController?.isToolbarHidden = true
            }
            
        }
    
//    override func viewDidAppear(_ animated: Bool) {
//        userPhotoUpdated()
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        videoStruct.updateDidGoBack(newBool: true)
    }
    
    
    func getFollowing(id: String) {
        GETUsersByFollowerId(id: id).getAllById {
            self.checkFollowing = Set($0.map{String($0.user_id!)})
        }
    }
    
    func setupButton(id:String?) {
        if let followingUsers = self.checkFollowing {
            if (followingUsers.contains(id!)) {
                followButton.buttonState = .delete
                print("delete flwer btn")
            } else {
                followButton.buttonState = .add
                print("add flwer btn")
            }
        }
        print("setupButton")
    }
    
    func getUser(completion: @escaping(()->())) {
            if let id = profile?.sub {
            print("profile?.sub id \(profile?.sub)")
            GetUsersById(id: id).getAllPosts {
                print("$0[0].username \($0[0].username)")
                if $0[0].username == nil {
                    GETUser(id: id, path: "getUserInfo").getAllById {
                       self.username = $0[0].username
                       completion()
                    }
                } else {
                    self.username = $0[0].username
                    completion()
                }
              }
            }
    }
    
    
    func userPhotoUpdated() {
        profile = SessionManager.shared.profile
         if let profile = profile {
            print("hellur 2")
                   GetUsersById(id: profile.sub).getAllPosts {
                       let photo = $0
                       self.imageLoader = DownloadImage()
                       self.imageLoader?.imageDidSet = { [weak self] image in
                           DispatchQueue.main.async {
                               self?.imageView.image = image
                               self?.view?.addSubview(self!.imageView)
                           }
                       }
                       self.imageLoader?.downloadImage(urlString: photo[0].picture!)
                       print("photo \(photo[0].picture)")
                   }
               }
    }
    
    func addCollectionView() {
          let child = ArtistPFContainerView()
          addChild(child)
          child.view.frame = view.frame
          view.addSubview(child.view)
          child.didMove(toParent: self)
          child.view.backgroundColor = UIColor.white
          self.view.bringSubviewToFront(child.view)
          child.view.translatesAutoresizingMaskIntoConstraints = false
          child.view.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60).isActive = true
          child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
          child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
          child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func addImagePH() {
           let imagePH = UIImage(named:"profile-placeholder-user")
           self.imageView = UIImageView(image: imagePH)
           self.view?.addSubview(self.imageView)
           setImageContraints()
    }
    
    func setImageContraints() {
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.imageView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView?.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.imageView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
}
    
    func userInfo() {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
            label?.textAlignment = .center
            self.view.addSubview(label!)
            label?.translatesAutoresizingMaskIntoConstraints = false
            label?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            label?.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
            if let username = self.username {
            label?.text = "\(username)"
            }

            imageLoader = DownloadImage()
                self.imageLoader?.imageDidSet = { [weak self] image in
                DispatchQueue.main.async {
                self?.imageView.image = image
                self?.view?.addSubview(self!.imageView)
                }
                self?.setImageContraints()
                }
        if let user_pic = users[0].picture {
            imageLoader?.downloadImage(urlString: user_pic)
        }

    }
    
    func followLabels() {
        followingTitle.text = "Following"
//        followingLabel.text = String(usersFollowed.count)
        followingLabel.text = "0"
        followingTitle.font = followingTitle.font.withSize(14)
        followingLabel.font = followingLabel.font.withSize(14)
        view.addSubview(followingTitle)
        view.addSubview(followingLabel)
        followLabelContraints()
        
//        followingTitle.isHidden = true
//        followingLabel.isHidden = true
        
        
        followingLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.followingLabelAction(_:)))
        followingLabel.addGestureRecognizer(gesture)
    }
    
    func usersWhoFollowLabels() {
        followsTitle.text = "Followers"
//        followsLabel.text = String(usersWhoFollow.count)
        followsLabel.text = "0"
        followsTitle.font = followingTitle.font.withSize(14)
        followsLabel.font = followingLabel.font.withSize(14)
        view.addSubview(followsTitle)
        view.addSubview(followsLabel)
//        followsTitle.isHidden = true
//        followsLabel.isHidden = true
        usersWhoFollowLabelContraints()
        
        followsLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.followsLabelAction(_:)))
        followsLabel.addGestureRecognizer(gesture)
    }
    
    @objc func followingLabelAction(_ sender : UITapGestureRecognizer) {
        if let followUsersVC = followUsersVC {
        if usersFollowed.count != 0 {
        navigationController?.pushViewController(followUsersVC, animated: true)
        self.followUsersVC?.followTitle = "Following"
            }
        }
        print("followingLabel clicked")

    }
    
    @objc func followsLabelAction(_ sender : UITapGestureRecognizer) {
        if let usersWhoFollowVC = usersWhoFollowVC {
        if usersWhoFollow.count != 0 {
        navigationController?.pushViewController(usersWhoFollowVC, animated: true)
        self.usersWhoFollowVC?.followTitle = "Followers"
        print("followingLabel clicked")
            }
        }

    }
    
    func followLabelContraints() {
        self.followingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.followingLabel.topAnchor.constraint(equalTo: followingTitle.bottomAnchor).isActive = true
        
        self.followingTitle.translatesAutoresizingMaskIntoConstraints = false
        self.followingTitle.topAnchor.constraint(equalTo: followsLabel.bottomAnchor, constant: 15).isActive = true
        self.followingTitle.centerXAnchor.constraint(equalTo: followsLabel.centerXAnchor).isActive = true
        self.followingLabel.centerXAnchor.constraint(equalTo: followingTitle.centerXAnchor).isActive = true
        
        
        
    }
    
    func usersWhoFollowLabelContraints() {
            self.followsLabel.translatesAutoresizingMaskIntoConstraints = false
            self.followsLabel.topAnchor.constraint(equalTo: followsTitle.bottomAnchor).isActive = true
            
            self.followsTitle.translatesAutoresizingMaskIntoConstraints = false
            self.followsTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
           self.followsTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 13).isActive = true
            self.followsLabel.centerXAnchor.constraint(equalTo: followsTitle.centerXAnchor).isActive = true
        }
           

    func getArtist(id: String) {
        GetUsersById(id: id).getAllPosts {
            self.users = $0
        }
        
        GETUsersByFollowerId(id: id).getAllById {
            self.following = $0
            self.followingLabel.text = String($0.count)
        }
        
    }
    
    func getFollowers(id:String) {
        GETFollowersByUserID(id: id).getAllById {
            self.follows = $0
            self.followsLabel.text = String($0.count)
        }
    }
    
    
    func setFollowButtonConstraints() {
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        followButton.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -10).isActive = true
        
        followButton.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
    }
    
    @objc func setButtonAction() {
        if followButton.buttonState == .add {
             if let user_id = artistID, let follower_id = profile?.sub, let follower_username = self.username, let follower_picture = profile?.picture?.absoluteString {
              let follower = Follower(user_id: user_id, follower_id: follower_id, follower_username: follower_username, follower_picture: follower_picture )
              let postRequest = FollowerPostRequest(endpoint: "follower")
              
              postRequest.save(follower) { (result) in
                  switch result {
                  case .success(let follower):
                      print("Followed the user")
                      GetUsersById(id: follower_id).getAllPosts {
                          self.usersWhoFollow.append(contentsOf: $0)
                          print("usersFollowed \(self.usersFollowed.count)")
                      }
                      DispatchQueue.main.async {
                        self.delegate?.sendFollowData(myData: false)
                      }
                  case .failure(let error):
                      print("An error occurred \(error)")
                  }
              }
            }
              followButton.buttonState = .delete
        } else if followButton.buttonState == .delete {
          
                print("delete button pressed")
            if let user_id = artistID, let follower_id = profile?.sub {
                let deleteRequest = DLTFollowingRequest(user_id: user_id, follower_id: follower_id)
                
                deleteRequest.delete {(err) in
                    if let err = err {
                        print("Failed to delete", err)
                        return
                    }
                    print("Successfully deleted followed user from server")
                    DispatchQueue.main.async {
                    self.usersWhoFollow.removeAll(where: {
                        $0.user_id == user_id
                        return true
                    })
                    self.delegate?.sendFollowData(myData: true)
                    }
                    
                }
             }
             followButton.buttonState = .add
        }
               
    }
    
    func addActionToFlwBtn() {
        followButton.addTarget(self, action: #selector(setButtonAction), for: .touchUpInside)
    }
    
    
    
    
   
}



