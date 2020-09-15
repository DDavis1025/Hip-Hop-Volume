//
//  MainView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/24/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//
//
//  MainView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/24/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//
import Foundation
import UIKit
import SwiftUI
import Auth0
    

class MainView: Toolbar, UITableViewDelegate, UITableViewDataSource {
    
    private var myTableView: UITableView!
    var model:PostListViewModel?
    var child:SpinnerViewController?
    var cellTitle:UILabel?
    var cellDesc:UILabel?
    var usersLoaded:Bool? = false
    var getUserById:GetUsersById?
    var array = [String]()
    var userDictionary = [String: UsersModel]()
    var users = [UsersModel]() {
        didSet {
            print("users should be array \(users)")

            let group = DispatchGroup()
            for user in users {
                group.enter()
                if let user_id = user.user_id {
                userDictionary[user_id] = user
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
             self.usersLoaded = true
             self.myTableView.reloadData()
             self.refresher?.endRefreshing()
            }
            
            print("user dinctionary \(userDictionary)")

        }
    }
    var posts = [Post]() {
        didSet {
            self.child?.willMove(toParent: nil)
            self.child?.view.removeFromSuperview()
            self.child?.removeFromParent()
            myTableView.reloadData()
            
            print("posts right now \(posts)")
           
            func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
                var buffer = [T]()
                var added = Set<T>()
                for elem in source {
                    if !added.contains(elem) {
                        buffer.append(elem)
                        added.insert(elem)
                    }
                }
                return buffer
            }
            
            var authorId = [String]()
            for post in self.posts {
                authorId.append(post.author!)
            }
            
            
            let uniqueVals = uniq(source: authorId)
            print("unique vals \(uniqueVals)")
            
            for id in uniqueVals {
                    GetUsersById(id: id).getAllPosts {
                        self.users.append(contentsOf: $0)
                        print("got users for this \($0)")
              }
            }
            
      }
    }
    var albumVC:AlbumVC?
    var imageLoader:DownloadImage?
    var refresher:UIRefreshControl?
    
    var components:URLComponents = {
           var component = URLComponents()
           component.scheme = "http"
           component.host = "localhost"
           component.port = 8000
           return component
       }()
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        addSpinner()
//        auth0()
        Webservice().getAllPosts {
            self.posts = $0
        }

        refresher = UIRefreshControl()
        refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        
//        let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addTapped))
        let notification = UIBarButtonItem(title: "Notification", style: .plain, target: self, action: #selector(addTapped))
                   
        let whoToFollow = UIBarButtonItem(title: "toFollow", style: .plain, target: self, action: #selector(toFollowTapped))

//       navigationItem.leftBarButtonItem = profile
       navigationItem.leftBarButtonItem = notification
       navigationItem.rightBarButtonItem = whoToFollow
       navigationItem.rightBarButtonItem = logout
        
        addTableView()
        
        myTableView.addSubview(refresher!)
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false

        
        view.isUserInteractionEnabled = true

    }
    
    @objc func refresh() {
        Webservice().getAllPosts {
            self.posts = $0
        }
        
    }
    
    
    @objc func addTapped() {
//           let profileVC = ProfileViewController()
//           let profileView = ProfileVC()
           let notificationVC = NotificationVC()
           self.navigationController?.pushViewController(notificationVC, animated: true)
//           self.navigationController?.pushViewController(profileView, animated: true)
       }
       
   @objc func toFollowTapped() {
       let toFollowVC = WhoToFollowVC()
       self.navigationController?.pushViewController(toFollowVC, animated: true)
   }
    
    @objc func logoutTapped() {
            let authVC = AuthVC()
            SessionManager.shared.logout { (error) in
                guard error == nil else {
                // Handle error
                print("Error: \(error)")
                return
            }
        }
            print("Session manager credentials \(SessionManager.shared.credentials)")
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.isToolbarHidden = true
            self.navigationController?.isNavigationBarHidden = true
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
        
            self.myTableView = UITableView()
                    
                    
            self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
                            
            self.myTableView.frame.size.height = self.view.frame.height
        //
            self.myTableView.frame.size.width = self.view.frame.width
                    
                            
            self.myTableView.register(FeedCell.self, forCellReuseIdentifier: "MyCell")
           
                            self.myTableView.dataSource = self
                            self.myTableView.delegate = self
                    
            myTableView.delaysContentTouches = false
            self.view.addSubview(self.myTableView)
            
            self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

            self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

            self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
            myTableView.layoutMargins = UIEdgeInsets.zero
            myTableView.separatorInset = UIEdgeInsets.zero
            
                    
                    

       

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 140
       }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        albumVC = AlbumVC(post: posts[indexPath.row])
        navigationController?.pushViewController(albumVC!, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! FeedCell
            
        let post = posts[indexPath.row]
        
        cell.set(post: post)
       
        cell.setUser(user: userDictionary[posts[indexPath.row].author!])


        return cell
    }
    
    

}
