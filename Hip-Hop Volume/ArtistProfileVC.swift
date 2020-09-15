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

class ArtistProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var profile: UserInfo!
    var isLoaded:Bool? = false
    var imageView:UIImageView!
    var myTableView: UITableView!
    var author:[PostById]!
    var album:[Post]!
    var images:[UIImage]?
    var post:Post? {
        didSet {
            let vc = UIHostingController(rootView: Album(post: self.post!))
            self.navigationController?.pushViewController(vc, animated: true)
            print("posty \(post)")
        }
    }
    var label:UILabel? = nil
    var child:SpinnerViewController?
    var users = [UsersModel]() {
        didSet {
            DispatchQueue.main.async {
                print("usersdid \(self.users)")
                self.child?.willMove(toParent: nil)
                self.child?.view.removeFromSuperview()
                self.child?.removeFromParent()
                self.userInfo()

                self.setContraints()
            }
        }
    }
    var artistData = [ArtistModel]() {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
                print("Artist Data \(self.artistData)")
                self.isLoaded = true
                self.albumImages()

            }
        }
    }
    var posts:Array<Any> = []
    var artistID:String?
    
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
//            profile = SessionManager.shared.profile
            addSpinner()
            addTableView()
    
//            myTableView?.isHidden = true
            
            getArtist(id: artistID!)
          
            
            view.backgroundColor = UIColor.white
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
//                self.imageView?.translatesAutoresizingMaskIntoConstraints = false
//                self.myTableView?.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
//            }
              
            
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
//            label.center = CGPoint(x: 120, y: 120)
//            label.textAlignment = .center
//            label.text = "Name: \(users[0].name)"
//
////            let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
////            label2.center = CGPoint(x: 120, y: 140)
////            label2.textAlignment = .center
////            label2.text = "Email: \(email)"
//
//            let url = URL(string: users[0].picture!)
//            let data = try! Data(contentsOf: url!)
//            let image = UIImage(data: data)
//            imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 120, y: 160, width: 100, height: 100)
//
//            self.view.addSubview(label)
//            self.view.addSubview(label2)
//            self.view.addSubview(imageView)
            
            
//            if (ArtistProfileVC.shared.artistData != nil) {
//                myTableView.reloadData()
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                self.myTableView.reloadData()
//               print("theArtsit \(ArtistProfileVC.shared.artistData)")
//            }
//
//               DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
//                self.myTableView.reloadData()
//                           }
            
           

            
//            self.view.addSubview(myTableView)
//            self.view.addSubview(imageView!)
//            self.view.addSubview(imageView!)
        }
    
//    func getAlbumById(id: String) {
//        SecondWebService(id: id).getAllPostsById {
//            self.album = $0
//        }
//    }
//    
    func setContraints() {
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.myTableView?.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20).isActive = true
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
            label?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            label?.text = "Name: \(self.users[0].name!)"
            let url = URL(string: users[0].picture!)
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data)
            imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 120, y: 160, width: 100, height: 100)
            self.view.addSubview(imageView)
            self.imageView?.translatesAutoresizingMaskIntoConstraints = false
            self.imageView?.topAnchor.constraint(equalTo: label!.bottomAnchor, constant: 10).isActive = true

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
    
    func getAlbum(id: String) {
         GETAlbum(id: id).getPostsById() {
            self.post = $0
    }
    }

    func getArtist(id: String) {
        GetUsersById(id: id).getAllPosts {
            self.users = $0
        }
        
        print("users \(self.users)")
        
        _ = ArtistProfileVC()
        let getArtistById =  GETArtistById(id: id)
        getArtistById.getAllById {
            self.artistData = $0
       }
    }
    
    
   func albumImages() {
    var data:Data?
           self.images = self.artistData.map { path in
           let url = URL(string: String(self.components.url!.absoluteString + "/\(path.path!)"))
            print("url \(url)")
            if let thisURL = url {
            data = try! Data(contentsOf: thisURL)
            }
            return UIImage(data: data!)!
       }
        
    }
    
    
    
    func addTableView() {
        self.myTableView = UITableView()
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.myTableView.dataSource = self
        self.myTableView.delegate = self

        self.view.addSubview(self.myTableView)
        
        print("tbl view")
        
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 1, y: 50, width: 276, height: 30))
        headerView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)

        let labelView: UILabel = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: 276, height: 24))
        labelView.text = "Albums"

        headerView.addSubview(labelView)
        self.myTableView.tableHeaderView = headerView

        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false

        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        self.myTableView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

//        self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
            myTableView.layoutMargins = UIEdgeInsets.zero
            myTableView.separatorInset = UIEdgeInsets.zero
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(artistData[indexPath.row].title)")
//        getAlbumById(id: artistData[indexPath.row].id!)
        getAlbum(id: artistData[indexPath.row].id!)

        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
           cell.textLabel!.text = "playa playa"
           cell.textLabel!.text = "\(artistData[indexPath.row].title!)"
           cell.imageView!.image = images![indexPath.row]
            let itemSize = CGSize.init(width: 100, height: 100)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
            cell.imageView?.image!.draw(in: imageRect)
            cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
           print("Artist data \(artistData)")
           
           cell.translatesAutoresizingMaskIntoConstraints = false
           cell.layoutMargins = UIEdgeInsets.zero
//        }
           return cell
       }
    
   
}



