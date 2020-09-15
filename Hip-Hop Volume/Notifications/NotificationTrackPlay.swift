//
//  NotificationTrackPlay.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/4/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation


class NotificationTrackPlay: UIViewController {
    var player:AVPlayer?
    var post:Post?
    var username:String?
    var trackNameLabel:UILabel?
    var playing:Bool = false
    var justClicked:Bool? = false
    var mySlider:UISlider?
    var timer: Timer?
    var button:UIButton?
    var imageView = UIImageView()
    var imageLoader:DownloadImage?
    let trackPlay = TrackPlay()
    let album = ModelClass()
    var trackMedia:[MediaPath]?
    var trackName = ""
    var userAndFollow:UserPfAndFollow?
    var post_id:String?
    var comment_id:String?
    var parent_commentID:String?
    var commentsBtn:UIButton?
    var parentsubcommentid: String?
    var notificationType:String?
    var songData = [PostById]() {
          didSet {
              DispatchQueue.main.async {
                self.trackNameLabel?.text = self.songData[0].title
                if let imagePath = self.songData[2].path {
                    self.addTrackImage(path: imagePath)
                }
                if let author_id = self.songData[0].author {
                    self.author_id = author_id
                    self.addUserAndFollowView(id: author_id, completion: {
                        if let userFollowBtm = self.userAndFollow?.view.bottomAnchor {
                            print("got bottom anchor")
                            self.imageView.topAnchor.constraint(equalTo: userFollowBtm).isActive = true
                            }
                    })
                }
                
                if let path = self.songData[1].path {
                    self.components.path = "/\(path)"
                    if let url = self.components.url?.absoluteString {
                    self.play(url: ((NSURL(string: url)!)))
                        
                    if self.playing {
                        self.button?.setImage(UIImage(named: "pause"), for: .normal)
                    } else {
                        self.button?.setImage(UIImage(named: "play"), for: .normal)
                    }
                    
                
                    self.mySlider?.value = 0.0
                    if let duration = self.player?.currentItem?.asset.duration {
                    self.mySlider?.maximumValue = Float(CMTimeGetSeconds(duration))
                    }
                    self.timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                      
                    }
                }
                
                self.getComments()
                
            }
        }
    }
    var likeBtn:UIButton?
    var isLiked:Bool = false
    var profile = SessionManager.shared.profile
    
    lazy var numberOfLikes:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.sizeToFit()
        return label
    }()
    
    let timeRemainingLabel: UILabel = {
         let timeRemaining = UILabel()
         timeRemaining.text = "00:00"
         timeRemaining.textColor = UIColor.black
         return timeRemaining
     }()
     
     let timeElapsedLabel: UILabel = {
         let timeElapsed = UILabel()
         timeElapsed.text = "00:00"
         timeElapsed.textColor = UIColor.black
         return timeElapsed
     }()
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        return component
    }()

    var id:String?
    var author_id:String?
    func captureId(id:String) {
        self.id = id
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true
        let dismiss = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissVC))
        dismiss.tintColor = UIColor.black
        
        navigationItem.leftBarButtonItem = dismiss
        
        
        imageView.image = UIImage(named: "music-placeholder")
        view.addSubview(imageView)
        setImageViewConstraints()
        getSongData()
        
         addSlider()
         addLabels()
         view.backgroundColor = UIColor.white
         addButtons()
         view.addSubview(timeElapsedLabel)
         view.addSubview(timeRemainingLabel)
       
         setupConstraints()
        getUser()
        
        addCommentsButton()
        addCommentsBtnConstraints()
        addLikeButton()
        addLikeBtnConstraints()
        postLikeCount()
        
        trackPlay.updateViewAppeared(newBool: false)
        album.updateViewAppeared(newBool: false)
            
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.player?.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
        self.likeBtn?.tintColor = UIColor.black
        isLiked = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let supporter_id = profile?.sub, let post_id = post_id {
          GETLikeRequest(path: "postLikeByUserID", post_id: post_id, supporter_id: supporter_id).getLike {
              if $0.count > 0 {
                  let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                  self.likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
                  self.likeBtn?.tintColor = UIColor.red
                self.isLiked = true
              } else {
                  let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                  self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
                  self.likeBtn?.tintColor = UIColor.black
                self.isLiked = false
              }
            }
        }
        if let post_id = post_id {
            GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                self.numberOfLikes.text = "\($0.count)"
            }
        }

    }
    
    func getSongData() {
        GETMediaById(id: self.id, path: "track").getMedia {
            self.songData = $0
        }
    }
    
    
    func getUser() {
        if let id = profile?.sub {
            print("profile?.sub id \(profile?.sub)")
            GetUsersById(id: id).getAllPosts {
                self.username = $0[0].username
                print("self.username \(self.username)")
            }
        } else {
            print("profile?.sub \(profile?.sub)")
        }
    }
    
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addUserAndFollowView(id: String, completion: @escaping () -> ()) {
        userAndFollow = UserPfAndFollow(id: id)
        if let userAndFollow = userAndFollow {
          addChild(userAndFollow)
          userAndFollow.view.isUserInteractionEnabled = true
          view.addSubview(userAndFollow.view)
          view.bringSubviewToFront(userAndFollow.view)
          
          userAndFollow.didMove(toParent: self)
          self.view.bringSubviewToFront(userAndFollow.view)
          userAndFollow.view.translatesAutoresizingMaskIntoConstraints = false
          userAndFollow.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
          userAndFollow.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
          userAndFollow.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
          userAndFollow.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
          userAndFollow.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
          completion()
        }
         
    }
    
    func getComments() {
       if let comment_id = comment_id, let parentsubcommentid = parentsubcommentid, notificationType == "reply" {
           ParentSubCommentAndReply(parentsubcommentid: parentsubcommentid, reply_id: comment_id).getComments { comments in
           DispatchQueue.main.async {
           let commentVC = CommentVC()
           if let post_id = self.id {
           commentVC.post_id = post_id
           }
           commentVC.notificationSubComments = [comments[0]]
           commentVC.notificationParentSubComment = [comments[1]]
           if let parent_id = comments[1].parent_id {
           commentVC.notificationParentId = parent_id
           }
           let commentVC2 = UINavigationController(rootViewController: commentVC)
           commentVC2.modalPresentationStyle = .popover
           self.present(commentVC2, animated: true, completion: nil)
               
          }
         }
           
       } else if let comment_id = comment_id, let _ = parent_commentID, notificationType == "reply" || notificationType == "likedComment" {
           NotificationSubComment(id: comment_id).getComments { comments in
           DispatchQueue.main.async {
           let commentVC = CommentVC()
           
           if let post_id = self.id {
           commentVC.post_id = post_id
           }
           let subComment: [Comments] = [comments[0]]
           commentVC.notificationSubComments = subComment
           if let parent_id = comments[0].parent_id {
           commentVC.notificationParentId = parent_id
           }
           let commentVC2 = UINavigationController(rootViewController: commentVC)
           commentVC2.modalPresentationStyle = .popover
           self.present(commentVC2, animated: true, completion: nil)
       }
      }
       } else if let _ = comment_id, notificationType == "likedComment" || notificationType == "commentedPost" {
         let commentVC = CommentVC()
         print("goToPostView notifType 2 \(notificationType)")
         if let post_id = self.post_id {
         commentVC.post_id = post_id
         }
         if let notificationType = self.notificationType {
             commentVC.notificationType = notificationType
         }
         if let comment_id = self.comment_id {
             print("this is a comment_id \(comment_id)")
             commentVC.post_comment_id = comment_id
         }
         let commentVC2 = UINavigationController(rootViewController: commentVC)
         commentVC2.modalPresentationStyle = .popover
         self.present(commentVC2, animated: true, completion: nil)
     }
    }
    
    
    
    func addLabels() {
        trackNameLabel = UILabel()
        guard let trackNameLabel = trackNameLabel else {
            return
        }
        
        view.addSubview(trackNameLabel)
        
        addLabelConstraints()
}
    
    func addLabelConstraints() {
        self.trackNameLabel?.translatesAutoresizingMaskIntoConstraints = false
                                                                     
        trackNameLabel?.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        trackNameLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func addTrackImage(path: String) {
        components.path = "/\(path)"
        imageLoader = DownloadImage()
        imageLoader?.imageDidSet = { [weak self ] image in
            self?.imageView.image = image
            self?.view.addSubview(self!.imageView)
        }
        if let url = components.url?.absoluteString {
          imageLoader?.downloadImage(urlString: url)
        }
        
        
    }
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true

        
        imageView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
}
    
    
    func addSlider() {
            mySlider = UISlider(frame:CGRect(x: 10, y: 100, width: 300, height: 20))
            mySlider?.minimumValue = 0
            mySlider?.isContinuous = true
            mySlider?.tintColor = UIColor.black
            mySlider?.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            mySlider?.thumbTintColor = UIColor.black
               
            self.view.addSubview(mySlider!)

    }
    
    func addButtons() {
        button = UIButton()
//        if playing! {
//            button?.setImage(UIImage(named: "pause"), for: .normal)
//        } else {
//            button?.setImage(UIImage(named: "play"), for: .normal)
//        }
        button?.imageView?.contentMode = .scaleAspectFit
        button?.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        
        view.addSubview(button!)
    }
    
    @objc func buttonClicked(_: UIButton) {
        guard let player = self.player else { return }
        if self.playing {
            player.pause()
            button?.setImage(UIImage(named: "play"), for: .normal)
            trackPlay.updatePlaying(newBool: false)
        } else {
            player.play()
            trackPlay.updatePlaying(newBool: true)
            button?.setImage(UIImage(named: "pause"), for: .normal)
        }
    }

    

    
    func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return ""
        }
        return "\(minsStr):\(secsStr)"
    }
    
    @objc func updateSlider() {
        guard let player = self.player else { return }
        mySlider?.value = Float(CMTimeGetSeconds(player.currentTime()))
        let remainingTimeInSeconds = CMTimeGetSeconds((player.currentItem?.asset.duration)!) - CMTimeGetSeconds(player.currentTime())
                 
        timeRemainingLabel.text = getFormattedTime(timeInterval: remainingTimeInSeconds)
        timeElapsedLabel.text = getFormattedTime(timeInterval: CMTimeGetSeconds(player.currentTime()))

    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        guard let player = self.player else { return }
        if let duration = player.currentItem?.duration {
            _ = CMTimeGetSeconds(duration)
            let value = Float64(mySlider!.value)
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player.seek(to: seekTime)
        }

    }
    
    
    func play(url:NSURL)  {
               do {
                   try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                   try AVAudioSession.sharedInstance().setActive(true)

                try self.player = AVPlayer(url: url as URL)
                
                print("URL \(url)")
                
                self.player?.play()
                self.playing = true
                mySlider?.value = 0.0
                if let duration = self.player?.currentItem?.asset.duration {
                    mySlider?.maximumValue = Float(CMTimeGetSeconds(duration))
                }
                timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)

                button?.setImage(UIImage(named: "pause"), for: .normal)
               } catch let error {
                   print(error.localizedDescription)
               }
               
//               return player
    }
    
    func setupConstraints() {
        self.timeRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeElapsedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mySlider?.translatesAutoresizingMaskIntoConstraints = false
        self.button?.translatesAutoresizingMaskIntoConstraints = false
                                                              
        timeElapsedLabel.leadingAnchor.constraint(equalTo: self.mySlider!.leadingAnchor).isActive = true

        timeRemainingLabel.trailingAnchor.constraint(equalTo: self.mySlider!.trailingAnchor).isActive = true
        
        timeElapsedLabel.topAnchor.constraint(equalTo: self.mySlider!.bottomAnchor).isActive = true
        timeRemainingLabel.topAnchor.constraint(equalTo: self.mySlider!.bottomAnchor).isActive = true
        
        mySlider?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        mySlider?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        mySlider?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        mySlider?.topAnchor.constraint(equalTo: (self.trackNameLabel?.bottomAnchor)!, constant: 20).isActive = true
        
        button?.centerXAnchor.constraint(equalTo: self.mySlider!.centerXAnchor).isActive = true
        
        button?.topAnchor.constraint(equalTo: self.timeElapsedLabel.bottomAnchor, constant: 20).isActive = true
        
        button?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        button?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    
    
    }
        
}


extension NotificationTrackPlay {
    
    func addCommentsButton() {
        let commentsBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        commentsBtn = UIButton()
        commentsBtn?.setImage(UIImage(systemName: "message", withConfiguration: commentsBtnConfig), for: .normal)
        commentsBtn?.addTarget(self, action: #selector(commentsBtnClicked(_:)), for: .touchUpInside)
        commentsBtn?.tintColor = UIColor.black
        if let commentsBtn = commentsBtn {
        view.addSubview(commentsBtn)
        }
    }
    
    func addCommentsBtnConstraints() {
        commentsBtn?.translatesAutoresizingMaskIntoConstraints = false
        commentsBtn?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        commentsBtn?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
    }
    
    @objc func commentsBtnClicked(_ sender: UIButton) {
        let commentVC = CommentVC()
        if let post_id = self.id {
        commentVC.post_id = id
        }
        let commentVC2 = UINavigationController(rootViewController: commentVC)
        commentVC2.modalPresentationStyle = .popover
        self.present(commentVC2, animated: true, completion: nil)
    }
    
}


extension NotificationTrackPlay {
    
    func addLikeButton() {
        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        likeBtn = UIButton()
        likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
        likeBtn?.addTarget(self, action: #selector(likeBtnClicked(_:)), for: .touchUpInside)
        likeBtn?.tintColor = UIColor.black
        if let likeBtn = likeBtn {
        view.addSubview(likeBtn)
        }
    }
    
    func addLikeBtnConstraints() {
        likeBtn?.translatesAutoresizingMaskIntoConstraints = false
        guard let commentsBtn = commentsBtn else {
            return
        }
        likeBtn?.centerYAnchor.constraint(equalTo: commentsBtn.centerYAnchor).isActive = true
        
        likeBtn?.centerXAnchor.constraint(equalTo: commentsBtn.centerXAnchor, constant: -80).isActive = true
    }
    
    func postLikeCount() {
        guard let likeBtn = likeBtn else {
            return
        }
        view.addSubview(numberOfLikes)
        numberOfLikes.translatesAutoresizingMaskIntoConstraints = false
        numberOfLikes.centerXAnchor.constraint(equalTo: likeBtn.centerXAnchor).isActive = true
        numberOfLikes.bottomAnchor.constraint(equalTo: likeBtn.topAnchor, constant: -5).isActive = true
    }
    
    @objc func likeBtnClicked(_ sender: UIButton) {
          if self.isLiked == true {
            let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
            likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
            likeBtn?.tintColor = UIColor.black
            if let supporter_id = profile?.sub, let post_id = self.post_id {
                    let deleteRequest = DLTLike(post_id: post_id, supporter_id: supporter_id)
                
                deleteRequest.delete {(err) in
                    if let err = err {
                        print("Failed to delete", err)
                        return
                    }
                     if let post_id = self.post_id {
                        GETLikeRequest(path: "getLikesByPostID", post_id: self.post_id, supporter_id: nil).getLike {
                            self.numberOfLikes.text = "\($0.count)"
                        }
                    }
                    
                    print("Successfully deleted post like from server")
                }
            }
            isLiked = false
        } else {
            print("liked post")
            let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold, scale: .medium)
            likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
            likeBtn?.tintColor = UIColor.red
           if let supporter_id = profile?.sub, let supporter_username = self.username, let supporter_picture = profile?.picture?.absoluteString, let user_id = self.author_id, let post_id = self.post_id {
            let postLike = LikeModel(user_id: user_id, supporter_id: supporter_id, supporter_username: supporter_username, supporter_picture: supporter_picture, post_id: post_id, post_type: "track")
            
            
            let postRequest = LikeRequest(endpoint: "postLike")
            postRequest.save(postLike) { (result) in
                switch result {
                case .success(let comment):
                    print("success: you liked a post")
                    if let post_id = self.post_id {
                        GETLikeRequest(path: "getLikesByPostID", post_id: self.post_id, supporter_id: nil).getLike {
                            self.numberOfLikes.text = "\($0.count)"
                        }
                    }
                case .failure(let error):
                    print("An error occurred while liking post: \(error)")
                }
            }
          }
           isLiked = true
      }
    }
    
}

