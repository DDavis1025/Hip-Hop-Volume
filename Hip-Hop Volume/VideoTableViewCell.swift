//
//  VideoTableViewCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/8/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Combine

class VideoTableViewCell: FeedCell {
    
    override func setImageConstraints() {
        super.setImageConstraints()
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        mediaImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mediaImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        mediaImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        mediaImage.heightAnchor.constraint(equalToConstant: 60.7).isActive = true
        mediaImage.widthAnchor.constraint(equalToConstant: 108).isActive = true
        
    }
    
    override func setImagePHConstraints() {
        mediaPH.translatesAutoresizingMaskIntoConstraints = false
        mediaPH.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mediaPH.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        mediaPH.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        mediaPH.heightAnchor.constraint(equalToConstant: 60.7).isActive = true
        mediaPH.widthAnchor.constraint(equalToConstant: 108).isActive = true
        
    }
    
    
   
        
       
        
        override func setArtistContstraints() {
              mediaArtist.translatesAutoresizingMaskIntoConstraints = false
              mediaArtist.centerXAnchor.constraint(equalTo: mediaTitle.centerXAnchor).isActive = true
            mediaArtist.topAnchor.constraint(equalTo: mediaImage.topAnchor, constant: 3).isActive = true
              mediaArtist.heightAnchor.constraint(equalToConstant: 20).isActive = true
           }
        
        
        override func setTitleContstraints() {
            mediaTitle.translatesAutoresizingMaskIntoConstraints = false
            mediaTitle.topAnchor.constraint(equalTo: mediaArtist.bottomAnchor, constant: 4).isActive = true
            mediaTitle.leadingAnchor.constraint(equalTo: mediaImage.trailingAnchor, constant: 20).isActive = true
            mediaTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
    
    
    
}
