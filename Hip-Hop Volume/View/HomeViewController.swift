//
//  MainView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/24/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

//
//  MainView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/24/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//
import Foundation
import UIKit
import SwiftUI
import Auth0
import GoogleMobileAds
    

class HomeViewController: Toolbar, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let videoId = "videoId"
    let tracksId = "tracksId"
    var albumVC:AlbumVC?
    var userAndFollowVC:UserPfAndFollow?
    var bannerView: GADBannerView!
    var profile = SessionManager.shared.profile
    var product: SKProduct?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//          guard let product = product else { return }
         
//         if HipHopVolumeProducts.store.isProductPurchased(product.productIdentifier) {
//            print("isPurchased true")
//        }
//        POSTAuth0().post(completion: {})
        view.backgroundColor = UIColor.white
        setupMenuBar()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        setupCollectionView()
       self.navigationController?.isNavigationBarHidden = false
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
//        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
               
//        let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addTapped))
        
        let notification = UIBarButtonItem(title: "Notification", style: .plain, target: self, action: #selector(addTapped))
                          
        let whoToFollow = UIBarButtonItem(title: "toFollow", style: .plain, target: self, action: #selector(toFollowTapped))
        
        let comment = UIBarButtonItem(title: "Comment", style: .plain, target: self, action: #selector(toCommentTapped))
        
//        let adMobTest = UIBarButtonItem(title: "AdMob", style: .plain, target: self, action: #selector(adMobTestTapped))
        

//        navigationItem.leftBarButtonItem = profile
//        navigationItem.leftBarButtonItem = notification
//        navigationItem.rightBarButtonItem = whoToFollow
//        navigationItem.rightBarButtonItem = logout
//          navigationItem.rightBarButtonItem = adMobTest
         
//         self.navigationController?.isNavigationBarHidden = false

//        auth0()
        navigationController?.isToolbarHidden = false
        
        print("navigation toolbar \(self.navigationController?.toolbar.barTintColor)")
        
        if let id = profile?.sub {
        print("profile?.sub id \(profile?.sub)")
        GetUsersById(id: id).getAllPosts {
            print("$0[0].username \($0[0].username)")
            if $0[0].username == nil {
                GETUser(id: id, path: "getUserInfo").getAllById {
                    if $0.count <= 0 {
                        self.addUsernameAlert()
                }
              }
            }
          }
        }

    }
    
    func addUsernameAlert() {
        let alert = UIAlertController(title: "Hello", message: "Please Enter a Username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                self.addUsername()
            }))
                self.present(alert, animated: true, completion: nil)
        }

   func addUsername() {
    navigationController?.pushViewController(UsernameTextField(), animated: true)
  }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     bannerView.backgroundColor = UIColor.lightGray
     view.addSubview(bannerView)
     bannerView.topAnchor.constraint(equalTo: self.menuBar.bottomAnchor).isActive = true
     bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
     bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared")
//        self.navigationController?.isNavigationBarHidden = false
        addGesture()
    }
    
    
    
    func pushToAlbumVC(post: Post) {
        albumVC = AlbumVC(post: post)
        navigationController?.pushViewController(self.albumVC!, animated: true)
    }
    
//    @objc func adMobTestTapped() {
//        let adMobVC = AdTest()
//        self.navigationController?.pushViewController(adMobVC, animated: true)
//    }
    
    @objc func toCommentTapped() {
        let commentVC = CommentVC()
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    @objc func addTapped() {
//            let profileVC = ProfileViewController()
//            let profileView = ProfileVC()
//            self.navigationController?.pushViewController(profileView, animated: true)
         let notificationVC = NotificationVC()
         self.navigationController?.pushViewController(notificationVC, animated: true)
        }
        
    @objc func toFollowTapped() {
        let toFollowVC = WhoToFollowVC()
        self.navigationController?.pushViewController(toFollowVC, animated: true)
    }
     
    
//     @objc func logoutTapped() {
//             let authVC = AuthVC()
//             SessionManager.shared.logout { (error) in
//                 guard error == nil else {
//                 // Handle error
//                 print("Error: \(error)")
//                 return
//             }
//         }
//             print("Session manager credentials \(SessionManager.shared.credentials)")
//             self.navigationController?.popToRootViewController(animated: true)
////             self.navigationController?.isToolbarHidden = true
////             self.navigationController?.isNavigationBarHidden = true
//             if let player = player {
//                player.pause()
//             }
//         }

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    func setupCollectionView() {
        
        view.addSubview(collectionView)
        
        view.bringSubviewToFront(collectionView)
        
        collectionView.isPagingEnabled = true
//        collectionView.backgroundColor = UIColor.gray
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
        
        
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TracksCell.self, forCellWithReuseIdentifier: tracksId)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoId)
        
        
    }
    
    lazy var menuBar:MenuBar = {
        let mb = MenuBar()
        mb.homeVC = self
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        self.menuBar.translatesAutoresizingMaskIntoConstraints = false
        self.menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        self.menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if indexPath.item == 1 {
            let tracksCell = collectionView.dequeueReusableCell(withReuseIdentifier: tracksId, for: indexPath) as! TracksCell
            tracksCell.parent = self
            return tracksCell
        } else if indexPath.item == 2 {
            let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: videoId, for: indexPath) as! VideoCell
            videoCell.parent = self
            return videoCell
        }
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AlbumCell
         cell.parent = self
        
        
         let colors: [UIColor] = [.yellow, .orange, .red]
         cell.backgroundColor = colors[indexPath.item]
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.size.width, height: view.safeAreaLayoutGuide.layoutFrame.size.height)
    }
    
    
    
    
    

}
