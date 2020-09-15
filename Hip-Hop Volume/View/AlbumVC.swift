//
//  AlbumVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/23/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class AlbumVC: Toolbar, FollowDelegateProtocol {
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
    var viewController:UIViewController?
    var imageView = UIImageView()
    var albumTitle: UILabel?
    var albumDescription:UILabel?
    var user:UILabel?
    var userModel:GetUserByIDVM?
    var image:UIImageView?
    var userImageView:UIImageView?
    var child:SpinnerViewController?
    var imageLoader:DownloadImage?
    var userImage:String?
    var authorID:String?
    var user_id:String?
    var userAndFollow:UserPfAndFollow?
    var followButton = FollowerButton()
    var following: Set<String>? {
           didSet {
               print("following \(following)")
               
           }
       }

 var profile = SessionManager.shared.profile
 init(post: Post) {
    self.post = post
    print("post Album \(post)")
    viewController = ViewController(post:post)
    
       components.scheme = "http"
       components.host = "localhost"
    
     
       components.port = 8000
    
    super.init(nibName: nil, bundle: nil)
    
    

}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        print("albumVC View controller loaded")

        
//        addSpinner()
        authorID = self.post?.author!
        if let id = authorID {
        self.userModel = GetUserByIDVM(id: id)
        addUserAndFollowView(id: id)
        }
        imageView.image = UIImage(named: "music-placeholder")
        self.view.addSubview(imageView)
        setImageViewConstraints()
        

        
        addAlbumImage()
        addLabels()
        addViewController()
        view.backgroundColor = UIColor.white


        

        
    }
    
    
    
    func addSpinner() {
        self.child = SpinnerViewController()
        if let child = self.child {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.backgroundColor = UIColor.white
        self.view.bringSubviewToFront(child.view)
        }
    }
    
    func addUserAndFollowView(id: String) {
        userAndFollow = UserPfAndFollow(id: id)
        userAndFollow?.fromPushedVC = true
        if let userAndFollow = userAndFollow {
          addChild(userAndFollow)
          userAndFollow.view.frame = view.frame
          userAndFollow.view.isUserInteractionEnabled = true
          view.addSubview(userAndFollow.view)
          view.bringSubviewToFront(userAndFollow.view)
          
          userAndFollow.didMove(toParent: self)
          self.view.bringSubviewToFront(userAndFollow.view)
          userAndFollow.view.translatesAutoresizingMaskIntoConstraints = false
          userAndFollow.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
          userAndFollow.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
          userAndFollow.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
          userAndFollow.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
          userAndFollow.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
         
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        _ = self.post?.author!
        print("authorID2 \(authorID)")
    }

    
    
    

    
    func addAlbumImage() {
        imageLoader = DownloadImage()
        self.imageLoader?.imageDidSet = { [weak self] image in
            self!.imageView.image = image
            self!.view.addSubview((self?.imageView)!)
            self?.setImageViewConstraints()
        }
        components.path = "/\(post!.path)"
        if let url = components.url?.absoluteString {
            imageLoader?.downloadImage(urlString: url)
            print("components url plus \(url)")
        }

//        print("components url \(url)")
    }
    
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 290).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 290).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        if let userAndFollow = userAndFollow?.view {
            imageView.topAnchor.constraint(equalTo: userAndFollow.bottomAnchor, constant: 20).isActive = true
        }
}
    
    func addLabels() {
        albumTitle = UILabel()
        let boldText = "Title: "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = (post!.title)!
        let normalString = NSMutableAttributedString(string:normalText)

        attributedString.append(normalString)
        
        albumTitle!.attributedText = attributedString
        
        albumDescription = UILabel()
        
        let boldTextDesc = "Description: "
        let attrsDesc = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedStringDesc = NSMutableAttributedString(string:boldTextDesc, attributes:attrsDesc)

        let normalTextDesc = (post!.description)!
        let normalStringDesc = NSMutableAttributedString(string:normalTextDesc)

        attributedStringDesc.append(normalStringDesc)
        
        albumDescription!.attributedText = attributedStringDesc

        
        view.addSubview(albumTitle!)
        view.addSubview(albumDescription!)
        
        addLabelConstraints()
    }
    

        func addLabelConstraints() {
            self.albumTitle?.translatesAutoresizingMaskIntoConstraints = false
            self.albumDescription?.translatesAutoresizingMaskIntoConstraints = false
                                                                         
            albumTitle?.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
            
            albumDescription?.topAnchor.constraint(equalTo: albumTitle!.bottomAnchor, constant: 20).isActive = true
            
            albumTitle?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
              albumTitle?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
           
            albumDescription?.numberOfLines = 3
//            albumDescription?.lineBreakMode = .byWordWrapping
             albumDescription?.adjustsFontSizeToFitWidth = false
             albumDescription?.lineBreakMode = .byTruncatingTail
            albumDescription?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
            albumDescription?.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        }
    
    func addViewController() {
        if let viewController = viewController {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        setVCConstraints()
        }

    }
    
    func setVCConstraints() {
        viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        viewController?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
              
        viewController?.view.topAnchor.constraint(equalTo: albumDescription!.bottomAnchor, constant: 20).isActive = true

        viewController?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        viewController?.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
    func setFollowButtonConstraints() {
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        followButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        followButton.centerYAnchor.constraint(equalTo: user!.centerYAnchor).isActive = true
    }

    

}


struct AlbumController: UIViewControllerRepresentable {
    var post:Post
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlbumController>) -> AlbumVC {
        return AlbumVC(post: post)
    }
    
    func updateUIViewController(_ uiViewController: AlbumVC, context: UIViewControllerRepresentableContext<AlbumController>) {

    }
    
    
}
