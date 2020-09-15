//
//  FeedCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/25/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Combine

class FeedCell:UITableViewCell {
    var mediaImage = UIImageView()
    var mediaPH = UIImageView()
    var mediaArtist = UILabel()
    var mediaTitle = UILabel()
    var artistImage = UIImageView()
    var artistPH = UIImageView()
    var imageLoader:DownloadImage?
    var imageLoaded:Bool? = false
    var user:[UsersModel]?
    var postAuthor:String?
    
     static var shared = FeedCell()
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "hiphopvolumebucket.s3.amazonaws.com"
        
        return component
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mediaPH.image = UIImage(named: "music-placeholder")
        artistPH.image = UIImage(named: "profile-placeholder-user")
//        mediaPH.image = UIImage(named: "music-placeholder")
        addSubview(mediaPH)
        addSubview(artistPH)
        setImagePHConstraints()

        addSubview(mediaImage)
        addSubview(mediaTitle)
        addSubview(mediaArtist)
        addSubview(artistPH)
        setArtistPHConstraints()
        addSubview(artistImage)
        setImageConstraints()
        setTitleContstraints()
        setArtistContstraints()
        setArtistImageContstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader?.dataTask?.cancel()
        mediaImage.image = nil
//        mediaPH.image = nil

    }
    
    func set(post: Post) {
        components.path = "/\(post.path)"
       
        self.imageLoader = DownloadImage()
        imageLoader?.imageDidSet = { [weak self] image in
            self?.mediaImage.image = image
            self?.mediaPH.image = nil
            }
        imageLoader?.downloadImage(urlString: components.url!.absoluteString)
        mediaTitle.text = post.title
        
        
    }
    

    func setUser(user: UsersModel?) {
        mediaArtist.text = user?.username ?? "undefined"
        self.imageLoader = DownloadImage()
           imageLoader?.imageDidSet = { [weak self] image in
                self?.artistImage.image = image
                self?.artistPH.isHidden = true
              }
        if let userPicture = user?.picture {
        imageLoader?.downloadImage(urlString: userPicture)
        }
    }
    
    func configureImageView() {
        
    }
    
    func configureTitleLabel() {
        
    }
    
    func setImageConstraints() {
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        mediaImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mediaImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        mediaImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        mediaImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        mediaImage.topAnchor.constraint(equalTo: topAnchor, constant: -10).isActive = true
        mediaImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        
    }
    
    func setImagePHConstraints() {
        mediaPH.translatesAutoresizingMaskIntoConstraints = false
        mediaPH.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mediaPH.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        mediaPH.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        mediaPH.heightAnchor.constraint(equalToConstant: 90).isActive = true
        mediaPH.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        mediaPH.topAnchor.constraint(equalTo: topAnchor, constant: -10).isActive = true
        
    }
    
    func setArtistPHConstraints() {
        artistPH.translatesAutoresizingMaskIntoConstraints = false
        artistPH.centerYAnchor.constraint(equalTo: mediaArtist.centerYAnchor).isActive = true
        artistPH.trailingAnchor.constraint(equalTo: mediaArtist.leadingAnchor, constant: -3).isActive = true
        artistPH.heightAnchor.constraint(equalToConstant: 25).isActive = true
        artistPH.leadingAnchor.constraint(equalTo: mediaTitle.leadingAnchor).isActive = true
        artistPH.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    func setArtistContstraints() {
          mediaArtist.translatesAutoresizingMaskIntoConstraints = false
          mediaArtist.centerXAnchor.constraint(equalTo: mediaTitle.centerXAnchor).isActive = true
           mediaArtist.bottomAnchor.constraint(equalTo: mediaTitle.topAnchor, constant: -5).isActive = true
           mediaArtist.heightAnchor.constraint(equalToConstant: 20).isActive = true
       }
    
    func setArtistImageContstraints() {
              artistImage.translatesAutoresizingMaskIntoConstraints = false
              artistImage.centerYAnchor.constraint(equalTo: mediaArtist.centerYAnchor).isActive = true
              artistImage.trailingAnchor.constraint(equalTo: mediaArtist.leadingAnchor, constant: -3).isActive = true
              artistImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
              artistImage.leadingAnchor.constraint(equalTo: mediaTitle.leadingAnchor).isActive = true
              artistImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
          }
    
    
    func setTitleContstraints() {
        mediaTitle.translatesAutoresizingMaskIntoConstraints = false
        mediaTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mediaTitle.leadingAnchor.constraint(equalTo: mediaImage.trailingAnchor, constant: 20).isActive = true
        mediaTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
}
