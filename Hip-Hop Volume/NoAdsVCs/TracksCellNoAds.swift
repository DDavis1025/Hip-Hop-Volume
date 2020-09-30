//
//  TracksCellNoAds.swift
//  Hip-Hop Volume
//
//  Created by Dillon Davis on 9/28/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class TracksCellNoAds: AlbumCellNoAds {
         override init(frame: CGRect) {
           super.init(frame: frame)
   //        addSpinner()
            addMainMethods()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addMainMethods() {
         addTableView()
         GetAllOfMediaType(path:"tracks").getAllPosts {
                    self.posts = $0
                    self.myTableView.reloadData()
                }

        refresher = UIRefreshControl()
        refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        myTableView.addSubview(refresher!)
        
        addSpinner()
    }
    
    
    @objc override func refresh() {
        GetAllOfMediaType(path:"tracks").getAllPosts {
            self.posts = $0
        }
        
    }
    
    override func addTableView() {
    super.addTableView()
           
        self.myTableView.register(FeedCell.self, forCellReuseIdentifier: "MyCell")
           
            
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                tableView.deselectRow(at: indexPath, animated: true)
                print("didSelect TrackCell row")
                if let id = posts[indexPath.row].id {
                 if let path = posts[indexPath.row].title {
                    if let author_id = posts[indexPath.row].author {
                  let trackVC = TrackPlayVC()
                  let author = Author()
                  trackVC.captureId(id: id)
                  trackVC.trackName = path
    //              trackVC.author_id = author_id
                  trackVC.justClicked = true
                  let trackPlay = TrackPlay()
                  trackPlay.updateAuthorID(newString: author_id)
                  author.updateAuthorID(newString: author_id)
                  let modalVC = UINavigationController(rootViewController: trackVC)
                  modalVC.modalPresentationStyle = .fullScreen

                  parent?.navigationController?.present(modalVC, animated: true, completion: nil)
                }
             }
           }
        }
    

    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! FeedCell
            
        let post = posts[indexPath.row]
        
        cell.set(post: post)
       
        cell.setUser(user: userDictionary[posts[indexPath.row].author!])


        return cell
    }
}
