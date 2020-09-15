//
//  NotificationViewModel.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 7/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit
import Foundation

class NotificationViewModel {
    var mainNotification: Notifications? {
        didSet {
            if let notificationMessage = mainNotification?.message {
                   if notificationMessage.contains("replied to your comment") {
                       notificationType = "reply"
                       notificationTypeDidSet?("reply")
                   } else if notificationMessage.contains("liked your comment") {
                       notificationType = "likedComment"
                       notificationTypeDidSet?("likedComment")
                   } else if notificationMessage.contains("started following you") {
                       print("contains following")
                       getFollowing()
                       notificationType = "follow"
                       notificationTypeDidSet?("follow")
                       flwBtnIsHidden = false
                       self.flwBtnIsHiddenDidSet?(false)
                       flwBtnIsEnabled = true
                       postImageIsHidden = true
                       self.postImageIsHiddenDidSet?(true)
                       postImageIsEnabled = false
                   } else if notificationMessage.contains("liked your post") {
                       notificationType = "likedPost"
                       notificationTypeDidSet?("likedPost")
                   } else if notificationMessage.contains("commented on your post") {
                       notificationType = "commentedPost"
                       notificationTypeDidSet?("commentedPost")
                   }
            }
        }
    }
    var profile = SessionManager.shared.profile
    var supporterImageDownloader: DownloadImage?
    var postImageDownloader: DownloadImage?
    var notificationType: String? { didSet { notificationTypeDidSet?(notificationType) } }
    var notificationTypeDidSet: ((String?)->())?
    var systemConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .medium)
    var flwBtnImage: UIImage?  { didSet { flwBtnImageDidSet?(flwBtnImage) } }
    var flwBtnImageDidSet: ((UIImage?)->())?
    var flwBtnTintColor: UIColor? = UIColor.black { didSet { flwBtnTintColorDidSet?(flwBtnTintColor) } }
    var flwBtnTintColorDidSet: ((UIColor?)->())?
    var isFollowed:Bool = false
    var followLoaded:Bool? = false
    var username:String?
    var flwBtnIsHidden: Bool? = true { didSet { flwBtnIsHiddenDidSet?(flwBtnIsHidden) } }
    var flwBtnIsHiddenDidSet: ((Bool?)->())?
    var flwBtnIsEnabled: Bool? = false { didSet { flwBtnIsEnabledDidSet?(flwBtnIsEnabled) } }
    var flwBtnIsEnabledDidSet: ((Bool?)->())?
    var postImageIsHidden: Bool? = false { didSet { postImageIsHiddenDidSet?(postImageIsHidden) } }
    var postImageIsHiddenDidSet: ((Bool?)->())?
    var postImageIsEnabled: Bool? = true { didSet { postImageIsEnabledDidSet?(postImageIsEnabled) } }
    var postImageIsEnabledDidSet: ((Bool?)->())?
    
    init() {
      flwBtnImage = UIImage(systemName: "person.badge.plus", withConfiguration: systemConfig)
    }
    
    
    func getFollowing() {
        if let user_id = mainNotification?.supporter_id, let follower_id = profile?.sub {
            GETFollows(user_id: user_id, follower_id: follower_id, path: "getFollower").getFollows {follow in
                if follow.count > 0 {
                    self.isFollowed = true
                    self.flwBtnImage = UIImage(systemName: "person.badge.minus.fill", withConfiguration: self.systemConfig)
                } else {
                    self.isFollowed = false
                    self.flwBtnImage = UIImage(systemName: "person.badge.plus", withConfiguration: self.systemConfig)
                }
        }
       }
       getUser()
       
    }
    
    func getUser() {
        if let id = profile?.sub {
            GetUsersById(id: id).getAllPosts {
                self.username = $0[0].username
            }
        }
    }
    
    func addDeleteFollower() {
        if isFollowed == false {
            if let follower_id = profile?.sub, let follower_picture = profile?.picture?.absoluteString, let user_id = mainNotification?.supporter_id, let name = profile?.name {
                let follower = Follower(user_id: user_id, follower_id: follower_id, follower_username: self.username ?? name, follower_picture: follower_picture )
              let postRequest = FollowerPostRequest(endpoint: "follower")
              
              postRequest.save(follower) { (result) in
                  switch result {
                  case .success(let follower):
                     print("success adding follower")
                     self.flwBtnImage = UIImage(systemName: "person.badge.minus.fill", withConfiguration: self.systemConfig)
                     self.isFollowed = true
                  case .failure(let error):
                      print("An error occurred \(error)")
                  }
              }
            } else {
                print("25 \(profile?.sub) \(profile?.picture?.absoluteString) \(mainNotification?.supporter_id) \(profile?.name)")
            }
//              isFollowed = true
        } else if isFollowed == true {
            if let user_id = mainNotification?.supporter_id, let follower_id = profile?.sub  {
                let deleteRequest = DLTFollowingRequest(user_id: user_id, follower_id: follower_id)
                
                deleteRequest.delete {(err) in
                    if let err = err {
                        print("Failed to delete", err)
                        return
                    }
                    print("Successfully deleted followed user from server")
                    self.flwBtnImage = UIImage(systemName: "person.badge.plus", withConfiguration: self.systemConfig)
                    self.isFollowed = false
                }
             }
//             isFollowed = false
        }
    }
    
    
    
    
 }
    
    



