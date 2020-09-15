//
//  VideoPlayerView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/2/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class VideoPlayerView: UIView {
    private var playerLayer: AVPlayerLayer?
    var player:AVPlayer?
    var isPlaying = false
    var videoURL:String?
    var secondToFadeOut = 5 // How many second do you want the view to idle before the button fades. You can change this to whatever you'd like.
    var timer:Timer = Timer() // Create the timer!
    var isTimerRunning:Bool = false // Need this to prevent multiple timers from running at the same time.
    
    func addVideoURL(video: String) {
        videoURL = video
        setupPlayer()
        playerLayer?.frame = bounds
        bringSubviewToFront(controlsContainerView)
        print("video URL \(videoURL)")
    }
    
    let activityIndicatorView:UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = UIColor.white
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .black, scale: .medium)
        let image = UIImage(systemName: "pause.fill", withConfiguration: config) as UIImage?
        let whiteImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.0
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.borderColor = UIColor.black.cgColor
        button.setImage(whiteImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause(_:)), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc func handlePause(_ sender: UIButton!) {
        print("pause clicked")
        if isPlaying {
            self.player?.pause()
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .medium)
            let play = UIImage(systemName: "play.fill", withConfiguration: config) as UIImage?
            let playImage = play?.withTintColor(.white, renderingMode: .alwaysOriginal)
            pausePlayButton.setImage(playImage, for: .normal)
        } else {
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .black, scale: .medium)
            let image = UIImage(systemName: "pause.fill", withConfiguration: config) as UIImage?
            let whiteImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
            pausePlayButton.setImage(whiteImage, for: .normal)
            self.player?.play()
        }
        
        secondToFadeOut = 5
        timer.invalidate()
        runTimer()

        
        isPlaying = !isPlaying
    }
    
    
    let videoLengthLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    let currentTimeLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.darkGray
        slider.maximumTrackTintColor = UIColor.white
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .black, scale: .medium)
        let thumb = UIImage(systemName: "circle.fill", withConfiguration: config) as UIImage?
        let thumbImage = thumb?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        slider.setThumbImage(thumbImage, for: .normal)
        
        slider.addTarget(self,
                         action: #selector(handleSliderChange),
                         for: .valueChanged)
        
        slider.addTarget(self,
                         action: #selector(mySliderBeganTracking),
                         for:.touchDown)

        slider.addTarget(self,
                         action: #selector(mySliderEndedTracking),
                         for: .touchUpInside)
        
        slider.addTarget(self,
                         action: #selector(mySliderEndedTrackingOut),
                         for: .touchUpOutside )
        
        return slider
    }()
    
    @objc func mySliderBeganTracking() {
        self.player?.pause()
    }
    
    @objc func mySliderEndedTracking() {
        if isPlaying {
        self.player?.play()
        }
    }
    
    @objc func mySliderEndedTrackingOut() {
        if isPlaying {
        self.player?.play()
        }
    }
    
    
    
    @objc func handleSliderChange() {
    
         if let duration = self.player?.currentItem?.duration{

           let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            print("totalSeconds \(totalSeconds)")
            print("videoSlider.value \(videoSlider.value)")
            print("value \(value)")
            let seekTime = CMTime(seconds: Double(value) , preferredTimescale: 600)
            self.player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (completedSeek) in
            })
        }
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.addGestureRecognizer(tapRecognizer)
        
        
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(videoLengthLabel)
        controlsContainerView.addSubview(currentTimeLabel)
        
        
        
        NSLayoutConstraint.activate([
          controlsContainerView.topAnchor.constraint(equalTo: topAnchor),
          controlsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
          controlsContainerView.trailingAnchor.constraint(equalTo: videoLengthLabel.leadingAnchor),
          controlsContainerView.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor)
        ])
        
        controlsContainerView.addSubview(activityIndicatorView)
        
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
//        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        currentTimeLabel.centerYAnchor.constraint(equalTo: videoLengthLabel.centerYAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: -10).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 10).isActive = true
        videoSlider.centerYAnchor.constraint(equalTo: videoLengthLabel.centerYAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        backgroundColor = UIColor.black
    }
    
    func runTimer() {
        // Create the timer to run a method (in this case... updateTimer) every 1 second.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        // Set the isTimerRunning bool to true
        isTimerRunning = true
    }
    
    
    @objc func updateTimer() {
        // Every 1 second that this method runs, 1 second will be chopped off the secondToFadeOut property. If that hits 0 (< 1), then run the fadeOutButton and invalidate the timer so it stops running.
        secondToFadeOut -= 1
        print(secondToFadeOut)
        if secondToFadeOut < 1 {
            fadeOutButton()
            timer.invalidate()
            isTimerRunning = false
        }
    }
    
    func fadeOutButton() {
        // Fade out your button! I also disabled it here. But you can do whatever your little heart desires.
        UIView.animate(withDuration: 0.5) {
            self.pausePlayButton.alpha = 0.25
        }
        self.pausePlayButton.isEnabled = false
        self.pausePlayButton.isHidden = true
    }
    
    func fadeInButton() {
        // Fade the button back in, and set it back to active (so it's tappable)
        UIView.animate(withDuration: 0.5) {
            self.pausePlayButton.alpha = 1
        }
        self.pausePlayButton.isEnabled = true
        self.pausePlayButton.isHidden = false
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        // When the view is tapped (based on the gesture recognizer), reset the secondToFadeOut property, fade in (and enable) the button.
        secondToFadeOut = 5
        fadeInButton()
        timer.invalidate()
        runTimer()
    }

    
    private func setupPlayer() {
        print("videoURL \(videoURL)")
        let urlString = videoURL
        if let urlString = urlString {
        if let url = URL(string: urlString) {
        self.player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.videoGravity = .resizeAspect
        
        self.layer.addSublayer(playerLayer)
        
        self.playerLayer = playerLayer
        self.player?.play()
        
        self.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        //track player progress
       let interval = CMTime(value: 1, timescale: 2)
        self.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let minutsString = String(format: "%02d", Int(seconds/60))
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            self.currentTimeLabel.text = "\(minutsString):\(secondsString)"
            
            if let duration = self.player?.currentItem?.duration{
                let durationSeconds = CMTimeGetSeconds(duration)
                self.videoSlider.value = Float(seconds / durationSeconds)
            }
        })
      }
    }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let player = self.player {
            if let duration = player.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                if !(seconds.isNaN || seconds.isInfinite) {
                let minutsText = String(format: "%02d", Int(seconds)/60)
                let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                videoLengthLabel.text = "\(minutsText):\(secondsText)"
            }
           }
          }
         }
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

struct Video {
    static var didGoBack:Bool?
    
    func updateDidGoBack(newBool: Bool) {
        Video.self.didGoBack = newBool
    }
}

class VideoVC: UIViewController, GADInterstitialDelegate {
    var bannerView: GADBannerView!
    static let shared = VideoVC()
    var id:String = ""
    var path:String?
    var username:String?
    var author:String?
    var video_title:String?
    var video_description:String?
    var userAndFollow:UserPfAndFollow?
    let title_label = UILabel()
    let description_label = UILabel()
    var commentsBtn:UIButton?
    var post_id:String?
    var comment_id:String?
    var parent_commentID:String?
    var parentsubcommentid: String?
    var notificationType:String?
    var isLiked:Bool?
    var likeBtn:UIButton?
    var profile = SessionManager.shared.profile
    var interstitial: GADInterstitial!
    
    
    lazy var numberOfLikes:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.sizeToFit()
        return label
    }()

    
    func passId(id:String) {
        self.id = id
        print("id \(id)")
    }

    
    private lazy var playerView: VideoPlayerView = {
        let playerView = VideoPlayerView(frame: .zero)
        playerView.backgroundColor = .black
        
        return playerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = createAndLoadInterstitial()

        print("VIDEO VIEW DID LOAD")
//        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
//                  back.tintColor = UIColor.black
//
//        self.navigationItem.leftBarButtonItem = back
        
        player?.pause()
        

        let trackPlay = TrackPlay()
        let album = ModelClass()
        trackPlay.updateViewAppeared(newBool: false)
        album.updateViewAppeared(newBool: false)
        
        view.backgroundColor = UIColor.white
        
        GetMedia(id: id, path: "video_path").getMedia {
            if let path = $0[0].path {
            self.path = path
            }
            print("video path \(self.path)")
            var components = URLComponents()
            components.scheme = "http"
            components.host = "localhost"
            components.port = 8000
            if let path = self.path {
            components.path = "/\(path)"
            if let url = components.url?.absoluteString {
              print("url \(url)")
              self.playerView.addVideoURL(video: url)
            }
            }
        }
        view.addSubview(playerView)
        getUser()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        addCommentsButton()
        addCommentsBtnConstraints()
        addLikeButton()
        addLikeBtnConstraints()
        postLikeCount()


        addTitle()
        addDescription()
        if let author = author {
            addUserAndFollowView(id: author)
        }
        getComments()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
        self.likeBtn?.tintColor = UIColor.black
        isLiked = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Video.didGoBack == true {
             let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .medium)
             let play = UIImage(systemName: "play.fill", withConfiguration: config) as UIImage?
             let playImage = play?.withTintColor(.white, renderingMode: .alwaysOriginal)
             playerView.pausePlayButton.setImage(playImage, for: .normal)
            print("didGoBack")
        }
        let videoStruct = Video()
        print("video struct \(Video.didGoBack)")
        videoStruct.updateDidGoBack(newBool: false)
       if let supporter_id = profile?.sub {
        GETLikeRequest(path: "postLikeByUserID", post_id: self.id, supporter_id: supporter_id).getLike {
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
            GETLikeRequest(path: "getLikesByPostID", post_id: self.id, supporter_id: nil).getLike {
                self.numberOfLikes.text = "\($0.count)"
            }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     bannerView.backgroundColor = UIColor.lightGray
     bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
     bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
     bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
      interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/5135589807")
      interstitial.delegate = self as? GADInterstitialDelegate
      interstitial.load(GADRequest())
      return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        print("did dismiss screen")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = view.safeAreaLayoutGuide.layoutFrame.size.width / 1.777777777777778
        playerView.frame = CGRect(x: view.safeAreaLayoutGuide.layoutFrame.origin.x, y: view.safeAreaLayoutGuide.layoutFrame.origin.y, width: view.safeAreaLayoutGuide.layoutFrame.size.width, height: height)
    }
    
//    
//    @objc func goBack(sender: UIBarButtonItem) {
//        if let player = playerView.player {
//           player.pause()
//        }
//        print("goBack")
////        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let player = playerView.player {
           playerView.isPlaying = false
           player.pause()
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
    
    func getComments() {
       if let comment_id = comment_id, let parentsubcommentid = parentsubcommentid, notificationType == "reply" {
           ParentSubCommentAndReply(parentsubcommentid: parentsubcommentid, reply_id: comment_id).getComments { comments in
           DispatchQueue.main.async {
           let commentVC = CommentVC()
           commentVC.post_id = self.id
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
           
       } else if let _ = comment_id, let _ = parent_commentID, notificationType == "reply" || notificationType == "likedComment" {
           NotificationSubComment(id: comment_id).getComments { comments in
           DispatchQueue.main.async {
           let commentVC = CommentVC()
           
           commentVC.post_id = self.id
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
    
    func addTitle() {
        if let video_title = video_title {
        title_label.text = video_title
        title_label.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.view.addSubview(title_label)
        }
        addTitleContraints()
    }
    
    func addTitleContraints() {
        title_label.translatesAutoresizingMaskIntoConstraints = false
        title_label.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 10).isActive = true
        title_label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        title_label.widthAnchor.constraint(equalTo: view!.widthAnchor).isActive = true
        title_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func addDescription() {
        if let video_desc = video_description {
        description_label.text = video_desc
        description_label.font = description_label.font.withSize(14.0)
        self.view.addSubview(description_label)
            
        }
        addDescContraints()
    }
    
    func addDescContraints() {
        description_label.translatesAutoresizingMaskIntoConstraints = false
        description_label.topAnchor.constraint(equalTo: title_label.bottomAnchor, constant: 7).isActive = true
        description_label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        description_label.widthAnchor.constraint(equalTo: view!.widthAnchor).isActive = true
        description_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func addUserAndFollowView(id: String) {
        userAndFollow = UserPfAndFollow(id: id)
        userAndFollow?.fromPushedVC = true
        if let userAndFollow = userAndFollow {
          addChild(userAndFollow)
          userAndFollow.view.isUserInteractionEnabled = true
          view.addSubview(userAndFollow.view)
          view.bringSubviewToFront(userAndFollow.view)
          
          userAndFollow.didMove(toParent: self)
          self.view.bringSubviewToFront(userAndFollow.view)
          userAndFollow.view.translatesAutoresizingMaskIntoConstraints = false
          userAndFollow.view.topAnchor.constraint(equalTo: description_label.bottomAnchor, constant: 8).isActive = true
          userAndFollow.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
          userAndFollow.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
          userAndFollow.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
          userAndFollow.view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
         
    }
}


extension VideoVC {
    
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
        
        commentsBtn?.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -20).isActive = true
    }
    
    @objc func commentsBtnClicked(_ sender: UIButton) {
        let commentVC = CommentVC()
        commentVC.post_id = id
        let commentVC2 = UINavigationController(rootViewController: commentVC)
        commentVC2.modalPresentationStyle = .popover
        self.present(commentVC2, animated: true, completion: nil)
    }
    
}

extension VideoVC {
    
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
                if let supporter_id = profile?.sub {
                    let deleteRequest = DLTLike(post_id: self.id, supporter_id: supporter_id)
                
                deleteRequest.delete {(err) in
                    if let err = err {
                        print("Failed to delete", err)
                        return
                    }
                    
                        GETLikeRequest(path: "getLikesByPostID", post_id: self.id, supporter_id: nil).getLike {
                            self.numberOfLikes.text = "\($0.count)"
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
            if let supporter_id = profile?.sub, let supporter_username = self.username, let supporter_picture = profile?.picture?.absoluteString, let user_id = self.author {
                let postLike = LikeModel(user_id: user_id, supporter_id: supporter_id, supporter_username: supporter_username, supporter_picture: supporter_picture, post_id: self.id, post_type: "video")
            
            
            let postRequest = LikeRequest(endpoint: "postLike")
            postRequest.save(postLike) { (result) in
                switch result {
                case .success(let comment):
                    print("success: you liked a post")
                        GETLikeRequest(path: "getLikesByPostID", post_id: self.id, supporter_id: nil).getLike {
                            self.numberOfLikes.text = "\($0.count)"
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

