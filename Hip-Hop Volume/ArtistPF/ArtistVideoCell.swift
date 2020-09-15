//
//  ArtistVideoCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/10/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class ArtistVideoCell: ArtistAlbumsCell {
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      if let artistID = ArtistStruct.artistID {
        self.getArtist(id: artistID)
      }
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func refresh() {
        if let id = ArtistStruct.artistID {
            let getArtistById =  GETArtistById2(id: id, path:"artist/video")
            getArtistById.getAllById {
                self.artistData = $0
                self.refresher?.endRefreshing()
           }
        }
    }
    
    override func getArtist(id: String) {
        let getArtistById =  GETArtistById2(id: id, path:"artist/video")
        getArtistById.getAllById {
            self.artistData = $0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                      let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
                       cell.textLabel!.text = "\(artistData[indexPath.row].title!)"
                       components.path = "/\(artistData[indexPath.row].path!)"
                         
                       cell.imageView!.image = UIImage(named: "music-placeholder")
                       let itemSize = CGSize.init(width: 112, height: 63)
                       UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                       let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                       cell.imageView?.image!.draw(in: imageRect)
                       cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                       UIGraphicsEndImageContext();
                   
                      cell.translatesAutoresizingMaskIntoConstraints = false
                      cell.layoutMargins = UIEdgeInsets.zero
                      
                       self.imageLoader = DownloadImage()
                        if let url = self.components.url?.absoluteString {
                        imageLoader?.imageDidSet = { [weak self] image in
                        cell.imageView!.image = image
                        let itemSize = CGSize.init(width: 112, height: 63)
                        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                        cell.imageView?.image!.draw(in: imageRect)
                        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                        UIGraphicsEndImageContext();
                       }
                       self.imageLoader?.downloadImage(urlString: url)
                      }
                      return cell
                  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let videoStruct = VideoStruct()
            if let video_id = artistData[indexPath.row].id, let author = artistData[indexPath.row].author, let description = artistData[indexPath.row].description, let title = artistData[indexPath.row].title  {
              let videoVC = VideoVC()
              videoStruct.updateVideoId(newString: video_id)
              videoVC.author = author
              videoVC.video_description = description
              videoVC.video_title = title
              videoVC.passId(id: video_id)
                
            parent?.navigationController?.pushViewController(videoVC, animated: true)
        }
        
    }
    
    
}

