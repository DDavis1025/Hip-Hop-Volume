import Foundation
import SwiftUI
import UIKit

class UserPfAndFollow: UIViewController, FollowDelegateProtocol {
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
    var username:String?
    var components = URLComponents()
    var imageView = UIImageView()
    var user:UILabel?
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
            self?.getUser(completion: {
            if let username = self?.username {
            self?.user!.text = username
            self?.view.addSubview(self!.user!)
            }
            
            self?.user_id = users[0].user_id
            self?.addImageAfterLoad()
            if let picture = users[0].picture {
            self?.imageLoader?.downloadImage(urlString: picture)
                }
            if let user_id = self?.user_id {
            self?.setupButton(id: user_id)
                }
                if let user_id = self?.user_id {
                    if let profile_sub = self?.profile?.sub {
                        if user_id != profile_sub {
                            if let self = self {
                            self.view.addSubview(self.followButton)
                            self.setFollowButtonConstraints()
                            self.view.bringSubviewToFront(self.followButton)
                           }
                        }
                    }
                }
                
                self?.view.isUserInteractionEnabled = true
              
            })
        }
        addImage()
        
        getFollowing(id: profile!.sub)
        
        addActionToFlwBtn()
    
        view.backgroundColor = UIColor.yellow
        
        view.bringSubviewToFront(followButton)


        print("navigation userandfollow \(navigationController)")

        
    }

    
    
    func getFollowing(id: String) {
        GETUsersByFollowerId(id: id).getAllById {
            self.following = Set($0.map{String($0.user_id!)})
        }
    }
    
    func getUser(completion: @escaping(()->())) {
            GetUsersById(id: self.id).getAllPosts {
            print("$0[0].username \($0[0].username)")
            if $0[0].username == nil {
                GETUser(id: self.id, path: "getUserInfo").getAllById {
                   self.username = $0[0].username
                   completion()
                }
            } else {
                self.username = $0[0].username
                completion()
            }
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
        
        print("profile?.sub user \(profile?.sub)")
        if followButton.buttonState == .add {
            if let follower_id = profile?.sub, let name = profile?.name, let follower_picture = profile?.picture?.absoluteString, let username = self.username {
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
           } else {
            print("username \(self.username) picture  \(profile?.picture?.absoluteString) user_id \(user_id)")
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
    
    
    
    func addImage() {
        let imagePH = UIImage(named: "profile-placeholder-user")
        userImageView = UIImageView(image: imagePH)
        view.addSubview(userImageView!)
        setUsersConstraints()
    }
    
    func addImageAfterLoad() {
        imageLoader = DownloadImage()
        self.imageLoader?.imageDidSet = { [weak self] image in
              self?.userImageView?.image = image
              self!.view.addSubview(self!.userImageView!)
              
              self!.setUsersConstraints()
              self?.child?.willMove(toParent: nil)
              self?.child?.view.removeFromSuperview()
              self?.child?.removeFromParent()
            
            let tap = UITapGestureRecognizer(target: self, action:  #selector(self?.userAction))
            let tap2 = UITapGestureRecognizer(target: self, action:  #selector(self?.userAction))
            
            self?.userImageView?.addGestureRecognizer(tap)
            self?.user?.addGestureRecognizer(tap2)
//
            self?.user?.isUserInteractionEnabled = true
            self?.userImageView?.isUserInteractionEnabled = true
    }

}
    
    
    func setUsersConstraints() {
               userImageView?.translatesAutoresizingMaskIntoConstraints = false
               userImageView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
               userImageView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
               userImageView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
               userImageView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
               user?.translatesAutoresizingMaskIntoConstraints = false
               user?.leadingAnchor.constraint(equalTo: userImageView!.trailingAnchor, constant: 10).isActive = true
               user?.centerYAnchor.constraint(equalTo: userImageView!.centerYAnchor).isActive = true
        
        
         
    }
    
    @objc func userAction(sender : UITapGestureRecognizer) {
    let artistPFVC = ArtistProfileVC()
    let artistStruct = ArtistStruct()
    artistPFVC.artistID = id
    artistStruct.updateArtistID(newString: id)
    artistPFVC.delegate = self
    if !fromPushedVC {
    artistPFVC.fromNowPlaying = true
    }
    navigationController?.pushViewController(artistPFVC, animated: true)
    }
    

    
    
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 290).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 290).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: userImageView!.bottomAnchor, constant: 20).isActive = true
}

    
    
    func setFollowButtonConstraints() {
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.bringSubviewToFront(followButton)
        
        followButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        followButton.centerYAnchor.constraint(equalTo: user!.centerYAnchor).isActive = true
    }

    

}



