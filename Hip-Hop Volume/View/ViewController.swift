//
//  ViewController.swift
//  Test
//
//  Created by Dillon Davis on 3/27/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

import UIKit
import SwiftUI
import AVFoundation

protocol AlbumVCDelegate {
    func updateTrackID(track_id:String)
}

class ViewController: Toolbar, UITableViewDelegate, UITableViewDataSource {
    
    private var myTableView: UITableView!
    var delegate:AlbumVCDelegate?
    var listArray:[PostById] = []
    var songArray:Array<Any> = []
    var songPath:Array<Any> = []
    var songId:Array<String> = []
    var albumId:Array<Any> = []
    let post:Post
    var otherSong:String?
    var trackPath:[String]?
    var components:URLComponents = {
           var component = URLComponents()
           component.scheme = "http"
           component.host = "localhost"
           component.port = 8000
           return component
       }()
    let modelClass = ModelClass()
    var albumData = [PostById]() {
        didSet {
            DispatchQueue.main.async {
                print("album data \(self.albumData[0].id)")
                self.trackPaths()
                let imagePath = self.albumData.filter { i in i.id == self.post.id
                }
                if let author_id = self.albumData[0].author {
                    self.modelClass.updateUserID(newString: author_id)
                }

                self.listArray = self.albumData.filter { i in i.album_id == self.post.id && i.id != self.post.id
                }

                self.components.path = "/\(self.albumData[0].path)"

                self.modelClass.updateImgPath(newText: self.components.url!.absoluteString)
                
                self.myTableView?.reloadData()
            }
        }
    }
    
    var playing:Bool?
    
    var indexPath:String?
    
    var navBar:UINavigationBar?
    
    var albumTrackBtnClicked:Bool? = false
    
    
    
    let trackVC = AlbumTrackVC()


    
    init(post: Post){
    self.post = post
    modelClass.updatePost(newPost: post)
    trackVC.post = post
    
    print("model class post \(ModelClass.post?.title)")

    super.init(nibName: nil, bundle: nil)
        
        getAlbumById(id: post.id!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        

        modelClass.updateTheViewLoaded(newBool: true)

        view.backgroundColor = UIColor.darkGray

        addTableView()
        addingNavBar()

        
        view.isUserInteractionEnabled = true

    }
    
    
    func albumTrackPush() {
           let mainVC = ViewController(post:post)
           self.navigationController?.pushViewController(mainVC, animated: true)
       }
    

    
    func addingNavBar() {
    DispatchQueue.main.async {
        if self.albumTrackBtnClicked! {
             print("addingNB Clicked!")
                
            self.navBar = UINavigationBar()
            self.navBar?.frame.size.width = self.view.frame.size.width
            self.navBar?.frame.size.height = 204
                    
            let navItem = UINavigationItem(title: self.post.title!)
                    let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
                    let image = UIImage(systemName: "chevron.left", withConfiguration: symbolConfig)

            
                        let doneItem = UIBarButtonItem(
                            image: image,
                            style: .plain,
                            target: self,
                            action: #selector(self.selectorName(sender:))
                        )
          doneItem.tintColor = UIColor.black
                    
           navItem.leftBarButtonItem = doneItem
          self.navBar?.barTintColor = UIColor.lightGray
        
           self.navBar!.setItems([navItem], animated: false)
                
           self.view.addSubview(self.navBar!)
        
          self.navBar?.translatesAutoresizingMaskIntoConstraints = false
            
            self.navBar?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        
            self.navBar?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

            self.navBar?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

                      self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
            
            self.myTableView?.topAnchor.constraint(equalTo: self.navBar!.bottomAnchor).isActive = true
                 
    
                
         }
        }
    }

    func getAlbumById(id: String) {
        SecondWebService(id: id).getAllPostsById {
            self.albumData = $0
        }
    }
    
    func trackPaths() {
        trackPath = self.albumData.map { path in
            components.path = "/\(path.path)"
            return components.url!.absoluteString
         }
        trackPath?.removeFirst()
        print("track path \(trackPath)")
        
    }
    
    
    func addTableView() {
        
            self.myTableView = UITableView()
                    
                    
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
                            
            self.myTableView.frame.size.height = self.view.frame.height
        //
            self.myTableView.frame.size.width = self.view.frame.width
                    
                            
            self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                            self.myTableView.dataSource = self
                            self.myTableView.delegate = self
                            self.myTableView.isScrollEnabled = true
                    
            myTableView.delaysContentTouches = false
            self.view.addSubview(self.myTableView)
                    
            if self.albumTrackBtnClicked! {
                print("yo yo yo")
                self.addingNavBar() } else {
            self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            }
            self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

            self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

            self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
            myTableView.layoutMargins = UIEdgeInsets.zero
            myTableView.separatorInset = UIEdgeInsets.zero
            
                    
                    

       

    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let trackName = listArray[indexPath.row].name {
        trackVC.trackNameLabel?.text = "\(trackName)"
        }
        if let track_id = listArray[indexPath.row].id {
        trackVC.track_id = "\(track_id)"
           modelClass.updatePostID(newString: track_id)
         print("didSelectRow \(track_id)")
        }
        
        modelClass.updateTrackNameLabel(newText: "\(listArray[indexPath.row].name!)")

        print("listArray \(listArray)")
        if let path = listArray[indexPath.row].path {
        modelClass.updateTrackPath(newText: path)
        }

        if !albumTrackBtnClicked! {
          modelClass.updateClickedFromAT(newBool: false)
          let author = Author()
          if let author_id = self.albumData[0].author {
             print("view controller author id \(author_id)")
             author.updateAuthorID(newString: author_id)
           }
          let modalVC = UINavigationController(rootViewController: trackVC)
          modalVC.modalPresentationStyle = .fullScreen

          self.navigationController?.present(modalVC, animated: true, completion: nil)
        } else {
          if let track = ModelClass.track {
              components.path = "/\(track)"
          }
          if let url = components.url {
              print("url \(url.absoluteString)")
            trackVC.play(url: (NSURL(string: url.absoluteString)!))
          }
          modelClass.updateClickedFromAT(newBool: true)
          if let track_id = listArray[indexPath.row].id {
            delegate?.updateTrackID(track_id: track_id)
          }
        }
        
        modelClass.updateListArray(newList: listArray)
        let index = indexPath.row
        modelClass.updateIndex(newInt: index)
        modelClass.updatePlaying(newBool: true)
        modelClass.updateJustClicked(newBool: true)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(listArray[indexPath.row].name!)"
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " Tracks"
    }

   
    
    @objc func selectorName(sender: UINavigationItem) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
//        albumTrackBtnClicked = false
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
       }
    
    
}



