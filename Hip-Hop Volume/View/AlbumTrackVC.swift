//
//  AlbumTrackVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation
import GoogleMobileAds


var player:AVPlayer?
class AlbumTrackVC: UIViewController, GADInterstitialDelegate {
    
    var bannerView: GADBannerView!
    var post:Post?
    var albumNameLabel:UILabel?
    var trackNameLabel:UILabel?
    var playing:Bool?
    var justClicked:Bool? = false
    var mySlider:UISlider?
    var timer: Timer?
    var button:UIButton?
    var goBackBtn:UIButton?
    var goForwardBtn:UIButton?
    var imageView = UIImageView()
    var albumTracksBtn:UIButton?
    var imageLoader:DownloadImage?
    let modelClass = ModelClass()
    let trackPlay = TrackPlay()
    var userAndFollow:UserPfAndFollow?
    var commentsBtn:UIButton?
    var likeBtn:UIButton?
    var isLiked:Bool = false
    var username:String?
    var profile = SessionManager.shared.profile
    var interstitial: GADInterstitial!
    var numberOfNext = NumberOfNext()
    
    var track_id:String?
    var fromNotificationCell:Bool?
    
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
    
    lazy var numberOfLikes:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.sizeToFit()
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()
        print("it loaded")
        navigationController?.isToolbarHidden = true
        let dismiss = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissVC))
        dismiss.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = dismiss
        
        print("Author \(Author.author_id)")
        imageView.image = UIImage(named: "music-placeholder")
        view.addSubview(imageView)
        if let author_id = Author.author_id {
            addUserAndFollowView(id: author_id, completion: {
                self.setImageViewConstraints()
                self.addAlbumImage()
            })
            print("it worked author_id \(author_id)")
        }
        
        addSlider()
        addLabels()
        print("MCp \(ModelClass.post)")
        view.backgroundColor = UIColor.white
        //        if let track = ModelClass.track {
        //            components.path = "/\(track)"
        //        }
        //        if let url = components.url {
        //            print("url \(url.absoluteString)")
        //            play(url: (NSURL(string: url.absoluteString)!))
        //          }
        if ModelClass.playing! {
            player?.play()
        }
        print("model class track \(ModelClass.track)")
        addButtons()
        view.addSubview(timeElapsedLabel)
        view.addSubview(timeRemainingLabel)
        if let image = ModelClass.imgPath {
            let imageView = UIHostingController(rootView: ImageView(withURL: image))
            view.addSubview(imageView.view)
        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        setupConstraints()
        addCommentsButton()
        addCommentsBtnConstraints()
        addLikeButton()
        addLikeBtnConstraints()
        postLikeCount()
        getUser()
        //         if let supporter_id = profile?.sub, let post_id = track_id {
        //            GETLikeRequest(path: "postLikeByUserID", post_id: post_id, supporter_id: supporter_id).getLike {
        //                if $0.count > 0 {
        //                    print("$0.count > 0")
        //                    let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        //                    self.likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
        //                    self.likeBtn?.tintColor = UIColor.red
        //                    self.modelClass.updateIsLiked(newBool: true)
        //                } else {
        //                    print("$0.count < 0")
        //                    let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        //                    self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
        //                    self.likeBtn?.tintColor = UIColor.black
        //                    self.modelClass.updateIsLiked(newBool: false)
        //                }
        //                print("$0.count after")
        //          }
        //        } else {
        //            print("track_id \(track_id) + supporter_id \(profile?.sub)")
        //        }
        
        
        
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
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self as? GADInterstitialDelegate
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        view.isUserInteractionEnabled = true
        if ModelClass.playing! {
            player?.play()
        }
        
        print("did dismiss screen")
    }
    
    func openAd() {
        guard let player = player else { return }
        if interstitial.isReady {
            //          player.pause()
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("it worked")
        guard let playing = ModelClass.playing else {
            return
        }
        if playing {
            button?.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            button?.setImage(UIImage(named: "play"), for: .normal)
        }
        trackNameLabel!.text = ModelClass.trackNameLabel
        
        print(ModelClass.justClicked)
        
        if ModelClass.justClicked! && !ModelClass.clickedFromAT! {
            if let track = ModelClass.track {
                components.path = "/\(track)"
            }
            if let url = components.url {
                print("url \(url.absoluteString)")
                play(url: (NSURL(string: url.absoluteString)!))
            }
            modelClass.updateJustClicked(newBool: false)
        }
        mySlider?.value = 0.0
        mySlider?.maximumValue = Float(CMTimeGetSeconds((player?.currentItem?.asset.duration)!))
        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
        self.likeBtn?.tintColor = UIColor.black
        self.modelClass.updateIsLiked(newBool: false)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear track_id \(track_id)")
        print("post_id album track \(ModelClass.post_id)")
        print("supporter id \(profile?.sub) + post_id \(track_id)")
        if let supporter_id = profile?.sub, let post_id = ModelClass.post_id {
            GETLikeRequest(path: "postLikeByUserID", post_id: post_id, supporter_id: supporter_id).getLike {
                if $0.count > 0 {
                    let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                    self.likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
                    self.likeBtn?.tintColor = UIColor.red
                    self.modelClass.updateIsLiked(newBool: true)
                } else {
                    let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                    self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
                    self.likeBtn?.tintColor = UIColor.black
                    self.modelClass.updateIsLiked(newBool: false)
                }
            }
        } 
        if let post_id = ModelClass.post_id {
            GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                self.numberOfLikes.text = "\($0.count)"
            }
        }
        print("$0.count after")
        trackPlay.updateViewAppeared(newBool: false)
        modelClass.updateViewAppeared(newBool: true)
        
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
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
    
    
    func addLabels() {
        albumNameLabel = UILabel()
        
        albumNameLabel!.text = ModelClass.post?.title
        
        trackNameLabel = UILabel()
        
        view.addSubview(albumNameLabel!)
        view.addSubview(trackNameLabel!)
        
        addLabelConstraints()
    }
    
    func addLabelConstraints() {
        self.albumNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.trackNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        //        albumNameLabel?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        albumNameLabel?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        albumNameLabel?.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        //        trackNameLabel?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        trackNameLabel?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackNameLabel?.topAnchor.constraint(equalTo: albumNameLabel!.bottomAnchor, constant: 20).isActive = true
        
        albumNameLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        trackNameLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func addAlbumImage() {
        if let path = ModelClass.post?.path {
            components.path = "/\(path)"
            print("imageView image 3")
        }
        imageLoader = DownloadImage()
        imageLoader?.imageDidSet = { [weak self ] image in
            print("imageView image 1 \(image)")
            self?.imageView.image = image
            if let self = self {
                self.view.addSubview(self.imageView)
            }
            
        }
        if let url = components.url?.absoluteString {
            print("imageView image 2")
            imageLoader?.downloadImage(urlString: url)
        }
        
        
    }
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let userView = userAndFollow?.view {
            imageView.topAnchor.constraint(equalTo: userView.bottomAnchor, constant: 20).isActive = true
        } else {
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        }
        
        
        imageView.widthAnchor.constraint(equalToConstant: 290).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 290).isActive = true
        
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
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold, scale: .medium)
        goBackBtn = UIButton()
        goForwardBtn = UIButton()
        goBackBtn?.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: symbolConfig), for: .normal)
        goBackBtn?.addTarget(self, action: #selector(goBackBtnClicked(_:)), for: .touchUpInside)
        goForwardBtn?.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: symbolConfig), for: .normal)
        goForwardBtn?.addTarget(self, action: #selector(goForwardBtnClicked(_:)), for: .touchUpInside)
        goBackBtn?.tintColor = UIColor.black
        goForwardBtn?.tintColor = UIColor.black
        
        let albumTracksBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold, scale: .medium)
        albumTracksBtn = UIButton()
        albumTracksBtn?.setImage(UIImage(systemName: "music.note.list", withConfiguration: albumTracksBtnConfig), for: .normal)
        albumTracksBtn?.addTarget(self, action: #selector(albumTracksBtnClicked(_:)), for: .touchUpInside)
        albumTracksBtn?.tintColor = UIColor.black
        
        view.addSubview(button!)
        view.addSubview(goBackBtn!)
        view.addSubview(goForwardBtn!)
        view.addSubview(albumTracksBtn!)
    }
    
    @objc func buttonClicked(_: UIButton) {
        guard let player = player else { return }
        if ModelClass.playing! {
            player.pause()
            button?.setImage(UIImage(named: "play"), for: .normal)
            modelClass.updatePlaying(newBool: false)
        } else {
            player.play()
            modelClass.updatePlaying(newBool: true)
            button?.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc func goBackBtnClicked(_: UIButton) {
        var index = ModelClass.index
        print("index go back \(index)")
        if NumberOfNext.numberOfNext == 13 {
            view.isUserInteractionEnabled = false
        }
        if index! > 0 {
            index! -= 1
            modelClass.updateIndex(newInt: index!)
            if let trackName = ModelClass.listArray![index!].name {
                modelClass.updateTrackNameLabel(newText: trackName)
            }
            if let index = index {
                if let path = ModelClass.listArray?[index].path {
                    components.path =  "/\(path)"
                }
            }
            if let index = index {
                if let post_id = ModelClass.listArray?[index].id {
                    modelClass.updatePostID(newString: post_id)
                }
            }
            if let supporter_id = profile?.sub, let post_id = ModelClass.post_id {
                GETLikeRequest(path: "postLikeByUserID", post_id: post_id, supporter_id: supporter_id).getLike {
                    if $0.count > 0 {
                        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                        self.likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
                        self.likeBtn?.tintColor = UIColor.red
                        self.modelClass.updateIsLiked(newBool: true)
                    } else {
                        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                        self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
                        self.likeBtn?.tintColor = UIColor.black
                        self.modelClass.updateIsLiked(newBool: false)
                    }
                }
            } else {
                print("track_id \(track_id) + supporter_id \(profile?.sub)")
            }
            if let post_id = ModelClass.post_id {
                GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                    self.numberOfLikes.text = "\($0.count)"
                }
            }
            
            if NumberOfNext.numberOfNext <= 12{
                var number = NumberOfNext.numberOfNext
                number += 1
                print("number now \(number)")
                numberOfNext.updateNumberOfNext(newInt: number)
                play(url: components.url! as NSURL)
            }
            if NumberOfNext.numberOfNext == 13 {
                openAd()
                play(url: components.url! as NSURL)
                player?.pause()
                numberOfNext.updateNumberOfNext(newInt: 0)
            } else if NumberOfNext.numberOfNext == 12  {
                let intersticialAdVM = IntersticialAdVM()
                intersticialAdVM.interstitial = intersticialAdVM.createAndLoadInterstitial()
                //            TrackPlayVC.shared.interstitial = intersticialAdVM.interstitial
                print("intersticial album track \(intersticialAdVM.interstitial)")
                TrackPlayVC.shared.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/5135589807")
                //            TrackPlayVC.shared.interstitial.delegate = TrackPlayVC.self as? GADInterstitialDelegate
                TrackPlayVC.shared.interstitial?.load(GADRequest())
            }
            trackNameLabel?.text = ModelClass.listArray![index!].name
            
            //            play(url: components.url! as NSURL)
            
            print("url gb \(components.url! as NSURL)")
        }
        
    }
    
    @objc func goForwardBtnClicked(_: UIButton) {
        if NumberOfNext.numberOfNext == 13 {
            view.isUserInteractionEnabled = false
        }
        var index = ModelClass.index
        if index! < ModelClass.listArray!.count - 1 {
            index! += 1
            modelClass.updateIndex(newInt: index!)
            print("index \(index)")
            
            if let trackName = ModelClass.listArray![index!].name {
                modelClass.updateTrackNameLabel(newText: trackName)
            }
            if let index = index {
                if let path = ModelClass.listArray?[index].path {
                    components.path =  "/\(path)"
                }
            }
            if let index = index {
                if let post_id = ModelClass.listArray?[index].id {
                    modelClass.updatePostID(newString: post_id)
                }
            }
            if let supporter_id = profile?.sub, let post_id = ModelClass.post_id {
                GETLikeRequest(path: "postLikeByUserID", post_id: post_id, supporter_id: supporter_id).getLike {
                    if $0.count > 0 {
                        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                        self.likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
                        self.likeBtn?.tintColor = UIColor.red
                        self.modelClass.updateIsLiked(newBool: true)
                    } else {
                        let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
                        self.likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
                        self.likeBtn?.tintColor = UIColor.black
                        self.modelClass.updateIsLiked(newBool: false)
                    }
                }
            } else {
                print("track_id \(track_id) + supporter_id \(profile?.sub)")
            }
            if let post_id = ModelClass.post_id {
                GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                    self.numberOfLikes.text = "\($0.count)"
                }
            }
            if NumberOfNext.numberOfNext <= 12{
                var number = NumberOfNext.numberOfNext
                number += 1
                print("number now \(number)")
                numberOfNext.updateNumberOfNext(newInt: number)
                play(url: components.url! as NSURL)
            }
            if NumberOfNext.numberOfNext == 13 {
                openAd()
                play(url: components.url! as NSURL)
                player?.pause()
                numberOfNext.updateNumberOfNext(newInt: 0)
            } else if NumberOfNext.numberOfNext == 12  {
                let intersticialAdVM = IntersticialAdVM()
                intersticialAdVM.interstitial = intersticialAdVM.createAndLoadInterstitial()
                //            TrackPlayVC.shared.interstitial = intersticialAdVM.interstitial
                print("intersticial album track \(intersticialAdVM.interstitial)")
                TrackPlayVC.shared.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/5135589807")
                //            TrackPlayVC.shared.interstitial.delegate = TrackPlayVC.self as? GADInterstitialDelegate
                TrackPlayVC.shared.interstitial?.load(GADRequest())
            }
            
            trackNameLabel?.text = ModelClass.listArray![index!].name
            //        play(url: components.url! as NSURL)
            print("url gf \(components.url! as NSURL)")
        }
    }
    
    @objc func albumTracksBtnClicked(_: UIButton) {
        let vc = ViewController(post: ModelClass.post!)
        vc.albumTrackBtnClicked = true
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
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
        guard let player = player else { return }
        mySlider?.value = Float(CMTimeGetSeconds(player.currentTime()))
        let remainingTimeInSeconds = CMTimeGetSeconds((player.currentItem?.asset.duration)!) - CMTimeGetSeconds(player.currentTime())
        
        timeRemainingLabel.text = getFormattedTime(timeInterval: remainingTimeInSeconds)
        timeElapsedLabel.text = getFormattedTime(timeInterval: CMTimeGetSeconds(player.currentTime()))
        
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        guard let player = player else { return }
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
            
            try player = AVPlayer(url: url as URL)
            
            print("URL \(url)")
            
            player?.play()
            modelClass.updatePlaying(newBool: true)
            
            mySlider?.value = 0.0
            if let duration = player?.currentItem?.asset.duration {
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
        self.goBackBtn?.translatesAutoresizingMaskIntoConstraints = false
        self.goForwardBtn?.translatesAutoresizingMaskIntoConstraints = false
        self.albumTracksBtn?.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        goBackBtn?.leadingAnchor.constraint(equalTo: self.button!.leadingAnchor, constant: -60).isActive = true
        
        goForwardBtn?.trailingAnchor.constraint(equalTo: self.button!.trailingAnchor, constant: 60).isActive = true
        
        goForwardBtn?.centerYAnchor.constraint(equalTo: self.button!.centerYAnchor).isActive = true
        
        goBackBtn?.centerYAnchor.constraint(equalTo: self.button!.centerYAnchor).isActive = true
        
        albumTracksBtn?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        albumTracksBtn?.bottomAnchor.constraint(equalTo: bannerView.topAnchor, constant: -15).isActive = true
        
        
    }
    
}


extension AlbumTrackVC {
    
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
        guard let albumTracksBtn = albumTracksBtn else {
            return
        }
        commentsBtn?.centerYAnchor.constraint(equalTo: albumTracksBtn.centerYAnchor).isActive = true
        
        commentsBtn?.centerXAnchor.constraint(equalTo: albumTracksBtn.centerXAnchor, constant: 80).isActive = true
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
    
    @objc func commentsBtnClicked(_ sender: UIButton) {
        let commentVC = CommentVC()
        if let post_id = ModelClass.post_id {
            commentVC.post_id = post_id
        }
        let commentVC2 = UINavigationController(rootViewController: commentVC)
        commentVC2.modalPresentationStyle = .popover
        self.present(commentVC2, animated: true, completion: nil)
    }
    
}


extension AlbumTrackVC {
    
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
        guard let albumTracksBtn = albumTracksBtn else {
            return
        }
        likeBtn?.centerYAnchor.constraint(equalTo: albumTracksBtn.centerYAnchor).isActive = true
        
        likeBtn?.centerXAnchor.constraint(equalTo: albumTracksBtn.centerXAnchor, constant: -80).isActive = true
    }
    
    
    
    @objc func likeBtnClicked(_ sender: UIButton) {
        print("model class is liked \(ModelClass.isLiked)")
        if ModelClass.isLiked == true {
            let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
            likeBtn?.setImage(UIImage(systemName: "heart", withConfiguration: likeBtnConfig), for: .normal)
            likeBtn?.tintColor = UIColor.black
            if let supporter_id = profile?.sub, let post_id = ModelClass.post_id {
                let deleteRequest = DLTLike(post_id: post_id, supporter_id: supporter_id)
                
                deleteRequest.delete {(err) in
                    if let err = err {
                        print("Failed to delete", err)
                        return
                    }
                    
                    if let post_id = ModelClass.post_id {
                        GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                            self.numberOfLikes.text = "\($0.count)"
                        }
                    }
                    
                    print("Successfully deleted post like from server")
                }
            }
            modelClass.updateIsLiked(newBool: false)
        } else {
            print("liked post")
            let likeBtnConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold, scale: .medium)
            likeBtn?.setImage(UIImage(systemName: "heart.fill", withConfiguration: likeBtnConfig), for: .normal)
            likeBtn?.tintColor = UIColor.red
            if let supporter_id = profile?.sub, let supporter_username = username, let supporter_picture = profile?.picture, let post_id = ModelClass.post_id, let user_id = ModelClass.user_id {
                let postLike = LikeModel(user_id: user_id, supporter_id: supporter_id, supporter_username: supporter_username, supporter_picture: supporter_picture.absoluteString, post_id: post_id, post_type: "album")
                
                
                let postRequest = LikeRequest(endpoint: "postLike")
                postRequest.save(postLike) { (result) in
                    switch result {
                    case .success(let comment):
                        print("success: you liked a post")
                        if let post_id = ModelClass.post_id {
                            GETLikeRequest(path: "getLikesByPostID", post_id: post_id, supporter_id: nil).getLike {
                                self.numberOfLikes.text = "\($0.count)"
                            }
                        }
                    case .failure(let error):
                        print("An error occurred while liking post: \(error)")
                    }
                }
            }
            modelClass.updateIsLiked(newBool: true)
        }
    }
    
}

extension AlbumTrackVC: AlbumVCDelegate {
    func updateTrackID(track_id: String) {
        modelClass.updatePostID(newString: track_id)
    }
    
    
}
