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
        
        let notificationVC = UINavigationController(rootViewController: NotificationVC())
        let notificationImage = UIImage(systemName: "bell")?.withRenderingMode(.alwaysOriginal)
        notificationVC.tabBarItem.image = notificationImage
        let notificationImageFill = UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysOriginal)
        notificationVC.tabBarItem.selectedImage = notificationImageFill
        
        
        let profileVC = UINavigationController(rootViewController: ProfileVC())
        let profileImage = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.image = profileImage
        let profileImageFill = UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.selectedImage = profileImageFill
        
        let noAdsVC = UINavigationController(rootViewController: NoAdsVC())
        let noAdsImage = UIImage(systemName: "hifispeaker")?.withRenderingMode(.alwaysOriginal)
        noAdsVC.tabBarItem.image = noAdsImage
        let noAdsFill =  UIImage(systemName: "hifispeaker.fill")?.withRenderingMode(.alwaysOriginal)
        noAdsVC.tabBarItem.selectedImage = noAdsFill
        noAdsVC.tabBarItem.title = "No Ads"
        
        checkForPurchase(completion: {
            if !self.isPurchased {
                self.viewControllers = [homeFeedController, notificationVC, profileVC, noAdsVC]
            } else {
                self.viewControllers = [homeFeedController, notificationVC, profileVC]
            }
            self.checkForNew(tabItem: (self.tabBar.items?[1])!)
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
    
    func checkForPurchase(completion: @escaping(()->())) {
        print("checkForPurchase")
        if let user_id = profile?.sub {
        GETPurchase(user_id: user_id, productIdentifier: "com.dillondavis.hiphopvolume.noads").getPurchase(completion: {
            if $0.count > 0 {
                self.isPurchased = true
                print("checkForPurchase isPurchased")
                let purchase = IsPurchased()
                purchase.updateIsPurchased(newBool: true)
                completion()
            } else {
                print("not purchased")
                completion()
                let purchase = IsPurchased()
                purchase.updateIsPurchased(newBool: false)
            }
          })
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    

}
