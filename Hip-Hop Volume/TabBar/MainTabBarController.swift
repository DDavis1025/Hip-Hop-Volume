//
//  MainTabBarController.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/18/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var profile = SessionManager.shared.profile
    var isPurchased:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("profile sub \(profile!.sub)")
        setUpTabBar()
        view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
        tabBar.barTintColor = UIColor.lightGray
        self.delegate = self
        print("it worked")
    }
    
    func setUpTabBar() {
        let homeFeedController = UINavigationController(rootViewController: HomeViewController())
        let homeImage = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal)
        homeFeedController.tabBarItem.image = homeImage
        let homeImageFill = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal)
        homeFeedController.tabBarItem.selectedImage = homeImageFill
        homeFeedController.tabBarItem.title = "Home"
        
        let uploadVC = UINavigationController(rootViewController: GoToUpload())
        let uploadImage = UIImage(systemName: "plus.app")?.withRenderingMode(.alwaysOriginal)
        uploadVC.tabBarItem.image = uploadImage
        let uploadFill =  UIImage(systemName: "plus.app.fill")?.withRenderingMode(.alwaysOriginal)
        uploadVC.tabBarItem.selectedImage = uploadFill
        uploadVC.tabBarItem.title = "Upload"
        
        
        let notificationVC = UINavigationController(rootViewController: NotificationVC())
        let notificationImage = UIImage(systemName: "bell")?.withRenderingMode(.alwaysOriginal)
        notificationVC.tabBarItem.image = notificationImage
        let notificationImageFill = UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysOriginal)
        notificationVC.tabBarItem.selectedImage = notificationImageFill
        notificationVC.tabBarItem.title = "Notifications"
        
        
        let profileVC = UINavigationController(rootViewController: ProfileVC())
        let profileImage = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.image = profileImage
        let profileImageFill = UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.selectedImage = profileImageFill
        profileVC.tabBarItem.title = "Profile"
        
        let premiumVC = UINavigationController(rootViewController: UpgradeToPremium())
        let premiumImage = UIImage(systemName: "hifispeaker")?.withRenderingMode(.alwaysOriginal)
        premiumVC.tabBarItem.image = premiumImage
        let premiumFill =  UIImage(systemName: "hifispeaker.fill")?.withRenderingMode(.alwaysOriginal)
        premiumVC.tabBarItem.selectedImage = premiumFill
        premiumVC.tabBarItem.title = "Premium"
        
        checkForPremium(completion: {
        self.viewControllers = [homeFeedController, uploadVC, notificationVC, profileVC, premiumVC]
        self.checkForNew(tabItem: (self.tabBar.items?[1])!)
            self.getCopyrightInfo()
        })
        
        
//        self.viewControllers = [homeFeedController, notificationVC, profileVC, noAdsVC]
//        self.checkForNew(tabItem: (self.tabBar.items?[1])!)
        
    }
    
    
    func checkForNew(tabItem: UITabBarItem) {
        if let user_id = profile?.sub {
        let getNotifications = GETNotifications(id: user_id, path: "getNewNotifications")
           getNotifications.getAllById { notifications in
            if notifications.count > 9 {
                    tabItem.badgeValue = "9+"
            } else if notifications.count > 0 && notifications.count <= 9 {
                     tabItem.badgeValue = "\(notifications.count)"
            } else {
                    tabItem.badgeValue = nil
            }
         }
      }
    }
    
    func checkForPremium(completion: @escaping(()->())) {
        print("checkForPurchase")
        if let user_id = profile?.sub {
        GETPremium(user_id: user_id).getPremium(completion: {
            print("\($0) premium user")
            if $0.count > 0 {
            if let status = $0[0].status {
            if status == "active" {
                self.isPurchased = true
                print("checkForPurchase isPurchased")
                let purchase = IsPremiumPurchased()
                purchase.updateIsPurchased(newBool: true)
                completion()
            } else {
                print("not purchased")
                completion()
                let purchase = IsPremiumPurchased()
                purchase.updateIsPurchased(newBool: false)
            }
            }
           } else {
            completion()
            let purchase = IsPremiumPurchased()
            purchase.updateIsPurchased(newBool: false)
        }
          })
        }
    }
    
    func getCopyrightInfo() {
        print("done getCopyrightInfo")
        if let user_id = profile?.sub {
        GETCopyrightInfo(user_id: user_id).get {
        print("done $0 \($0)")
            if $0.count > 0 {
                if $0[0].message != nil {
                self.present(CopyrightVC(data: $0), animated: true, completion: nil)
               }
            }
         }
       }
    }
    
//    func checkForPremium(completion: @escaping(()->())) {
//        print("checkForPurchase")
//        if let user_id = profile?.sub {
//        GETPurchase(user_id: user_id, productIdentifier: "com.dillondavis.hiphopvolume.premium").getPurchase(completion: {
////            print("time_added \(String($0[0].time_added!.prefix(10)))")
////            self.calculateTimeDifference(dateTime1: String($0[0].time_added!.prefix(10))) {
////                print("$0 \($0)")
////            }
//            if $0.count > 0 {
//                self.isPurchased = true
//                print("checkForPurchase isPurchased")
//                let purchase = IsPremiumPurchased()
//                purchase.updateIsPurchased(newBool: true)
//                completion()
//            } else {
//                print("not purchased")
//                completion()
//                let purchase = IsPremiumPurchased()
//                purchase.updateIsPurchased(newBool: false)
//            }
//          })
//        }
//    }
//

    
    


}
