//
//  IntersticialAdTest.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/25/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import GoogleMobileAds

class IntersticialAdTest: UIViewController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    
    lazy var button: UIButton = {
        var button = UIButton()
        button.setTitle("open ad", for: .normal)
        button.isHidden = false
        button.backgroundColor = UIColor.black
        button.tintColor = UIColor.white
        button.sizeToFit()
        button.addTarget(self, action: #selector(openAd), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        view.addSubview(button)
        view.bringSubviewToFront(button)
        buttonConstraints()
        interstitial = createAndLoadInterstitial()
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
    
    func buttonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func openAd() {
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
    }
}
