//
//  ProfileViewController.swift
//  Test
//
//  Created by Dillon Davis on 4/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Auth0


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var profile: UserInfo!
    var imageView:UIImageView!
    private var myTableView: UITableView!
    var author:[PostById]!
    var posts:Array<Any> = []
    var albumName:Array<Any> = []
//    var image: UIImage?

        override func viewDidLoad() {
            super.viewDidLoad()
            profile = SessionManager.shared.profile
            print("profile \(profile)")
            
            
//            if let profile = profile?.sub {
//            print("profile sub \(profile)")
//            }
//            if let profileAppMeta = profile.client_metadata {
//            print("Author \(profileAppMeta)")
//            }
            
            for post in author {
                albumName.append(post.title ?? "unAvailable")
            }
            
            view.backgroundColor = UIColor.white
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
            label.center = CGPoint(x: 120, y: 120)
            label.textAlignment = .center
            if let name = profile?.name {
                label.text = "Name: \(name)"
                print("Hello \(name)")
            }
            let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
            label2.center = CGPoint(x: 120, y: 140)
            label2.textAlignment = .center
            if let email = profile?.email {
            label2.text = "Email: \(email)"
            print("Hello email \(email)")
            }
            if let picture = profile.picture {
            let url = URL(string: picture.absoluteString)
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data)
            imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 120, y: 160, width: 100, height: 100)
            self.view.addSubview(imageView)
           }
//            {
//                var image = UIImage(data: data)!
//                print("Data \(data)")
////                imageView = UIImageView(image: image)
////                imageView.frame.origin = CGPoint(x: 160, y: 320)
//            }
//            DispatchQueue.main.async {
//            }
            self.view.addSubview(label)
            self.view.addSubview(label2)
            addTableView()
//            self.view.addSubview(myTableView)
//            self.view.addSubview(imageView!)
//            self.view.addSubview(imageView!)
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
                  
        self.myTableView?.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 100).isActive = true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(albumName[indexPath.row])")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(albumName[indexPath.row])"
        return cell
    }
}
