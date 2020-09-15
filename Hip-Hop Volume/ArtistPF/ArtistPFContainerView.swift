//
//  ArtistPFContainerView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/10/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit


class ArtistPFContainerView: HomeViewController {
    
    var albumId = "albumId"
    var atrackId = "atrackId"
    var avideoId = "avideoId"
    
    
    override func setupCollectionView() {
      super.setupCollectionView()
        
            
        collectionView.register(ArtistAlbumsCell.self, forCellWithReuseIdentifier: albumId)
        collectionView.register(ArtistTracksCell.self, forCellWithReuseIdentifier: atrackId)
        collectionView.register(ArtistVideoCell.self, forCellWithReuseIdentifier: avideoId)
            
            
        }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if indexPath.item == 1 {
            let tracksCell = collectionView.dequeueReusableCell(withReuseIdentifier: atrackId, for: indexPath) as! ArtistTracksCell
            tracksCell.parent = self
            return tracksCell
         } else if indexPath.item == 2 {
            let videosCell = collectionView.dequeueReusableCell(withReuseIdentifier: avideoId, for: indexPath) as! ArtistVideoCell
            videosCell.parent = self
            return videosCell
         }
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumId, for: indexPath) as! ArtistAlbumsCell
         cell.parent = self
        
         return cell
    }
}
