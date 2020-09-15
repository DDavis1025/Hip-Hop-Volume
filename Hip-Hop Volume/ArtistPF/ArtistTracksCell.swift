//
//  ArtistTracksCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/10/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class ArtistTracksCell: ArtistAlbumsCell {
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      if let artistID = ArtistStruct.artistID {
        self.getArtist(id: artistID)
      }
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getArtist(id: String) {
        let getArtistById =  GETArtistById2(id: id, path:"artist/track")
        getArtistById.getAllById {
            self.artistData = $0
        }
    }
    
    @objc override func refresh() {
           if let id = ArtistStruct.artistID {
               let getArtistById =  GETArtistById2(id: id, path:"artist/track")
                     getArtistById.getAllById {
                         self.artistData = $0
                  self.refresher?.endRefreshing()
              }
           }
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
        if let id = artistData[indexPath.row].id {
         if let title = artistData[indexPath.row].title {
            if let author = artistData[indexPath.row].author {
          let trackVC = TrackPlayVC()
          let authorStruct = Author()
          print("author_id now \(author)")
          authorStruct.updateAuthorID(newString: author)
          trackVC.captureId(id: id)
          trackVC.trackName = title
          trackVC.justClicked = true
          let modalVC = UINavigationController(rootViewController: trackVC)
          modalVC.modalPresentationStyle = .fullScreen

          parent?.navigationController?.present(modalVC, animated: true, completion: nil)
        }
       }
     }
    }
    
}
