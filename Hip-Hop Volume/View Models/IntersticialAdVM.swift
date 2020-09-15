//
//  IntersticialAdVM.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/26/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit
import Foundation
import GoogleMobileAds

class IntersticialAdVM: NSObject, GADInterstitialDelegate {
    var interstitial: GADInterstitial!
    
    func createAndLoadInterstitial() -> GADInterstitial {
      interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/5135589807")
      interstitial.delegate = self as? GADInterstitialDelegate
      interstitial.load(GADRequest())
      return interstitial
    }
    
    
}

