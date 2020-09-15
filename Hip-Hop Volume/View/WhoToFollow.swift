//
//  WhoToFollow.swift
//  Test
//
//  Created by Dillon Davis on 4/14/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Auth0


class WhoToFollowVC: Toolbar, UITableViewDelegate, UITableViewDataSource {

    var imageView:UIImageView!
    private var myTableView: UITableView!
    var images:Array<UIImage> = []
    var isLoaded:Bool? = false
    var child:SpinnerViewController?
    var imageLoader:DownloadImage?
    var users:[UsersModel]? {
        didSet {
            DispatchQueue.main.async {
//                self.addImage()
                self.isLoaded = true
                self.myTableView.reloadData()
                self.myTableView.isHidden = false
                self.child?.willMove(toParent: nil)
                self.child?.view.removeFromSuperview()
                self.child?.removeFromParent()
        }
     }
    }
    var image:UIImage?

    
    static var shared = WhoToFollowVC()
    

        override func viewDidLoad() {
            super.viewDidLoad()
//            GetUsersWebservice(accessToken: <#T##String#>).getAllPosts {
//                self.users = $0
//            }
            
            view.backgroundColor = UIColor.white
            
               addSpinner()
               addTableView()
               myTableView.isHidden = true
        
        }
    
    func addSpinner() {
          let child = SpinnerViewController()
          addChild(child)
          child.view.frame = view.frame
          view.addSubview(child.view)
          child.didMove(toParent: self)
          child.view.backgroundColor = UIColor.white
          self.view.bringSubviewToFront(child.view)
    }
    
    
    
    func addTableView() {
        myTableView = UITableView()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                   myTableView.dataSource = self
                   myTableView.delegate = self
        self.view.addSubview(myTableView)
        
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        self.myTableView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                  
        self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        myTableView.layoutMargins = UIEdgeInsets.zero
        myTableView.separatorInset = UIEdgeInsets.zero
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artistPFVC = ArtistProfileVC()
        print("Num: \(indexPath.row)")
        print("Value: \(users?[indexPath.row].name)")
        artistPFVC.artistID = users?[indexPath.row].user_id
        print("id \((users?[indexPath.row].user_id)!)")
//        artistPFVC.getArtist(id: (users?[indexPath.row].user_id)!)
        navigationController?.pushViewController(artistPFVC, animated: true)
}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return users?.count ?? 0

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
            cell.imageView!.image = UIImage(named: "profile-placeholder-user")
            if let username = users![indexPath.row].name {
            cell.textLabel!.text = "\(username)"
            }
        imageLoader = DownloadImage()
            imageLoader?.imageDidSet = { [weak self] image in
            cell.imageView!.image = image
            cell.translatesAutoresizingMaskIntoConstraints = false
            let itemSize = CGSize.init(width: 120, height: 120)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
            cell.imageView?.image!.draw(in: imageRect)
            cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
        }
        imageLoader?.downloadImage(urlString: (users?[indexPath.row].picture)!)
        let itemSize = CGSize.init(width: 120, height: 120)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
       UIGraphicsEndImageContext();
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    
}
