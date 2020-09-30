//
//  VideoCellNoAds.swift
//  Hip-Hop Volume
//
//  Created by Dillon Davis on 9/28/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class VideoCellNoAds: AlbumCellNoAds {
         override init(frame: CGRect) {
           super.init(frame: frame)
            addMainMethods()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addMainMethods() {
        addTableView()
        GetAllOfMediaType(path:"videos").getAllPosts {
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
        GetAllOfMediaType(path:"videos").getAllPosts {
            self.posts = $0
        }
        
    }
    
    override func addTableView() {
    super.addTableView()
           
        self.myTableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoTableViewCell")
           
            
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               tableView.deselectRow(at: indexPath, animated: true)
               let videoStruct = VideoStruct()
               if let id = posts[indexPath.row].id {
                   print("posts[indexPath.row].id \(posts[indexPath.row].id)")
               videoStruct.updateVideoId(newString: id)
               if let video_id = VideoStruct.id {
               let videoVC = VideoVC()
               if let id = VideoStruct.id {
               videoVC.passId (id: id)
               }
               if let author = posts[indexPath.row].author {
                 videoVC.author = author
               }
               if let description = posts[indexPath.row].description {
                 videoVC.video_description = description
               }
               if let title = posts[indexPath.row].title {
                 videoVC.video_title = title
               }

               parent?.navigationController?.pushViewController(videoVC, animated: true)

             }
          }
       }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as! VideoTableViewCell
            
        let post = posts[indexPath.row]
        
        cell.set(post: post)
       
        cell.setUser(user: userDictionary[posts[indexPath.row].author!])


        return cell
    }
}
