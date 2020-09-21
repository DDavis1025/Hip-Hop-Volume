//
//  NoAds.swift
//  Hip-Hop Volume
//
//  Created by Dillon Davis on 9/17/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class NoAdsVC: UIViewController {
    
    lazy var noAds:UILabel = {
        let label = UILabel()
        label.text = "No Ads"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 90)
        return label
    }()
    
    lazy var adFreeLabel:UILabel = {
        let label = UILabel()
        label.text = "\u{2022} Ad-free listening"
        label.textColor = UIColor.black
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    lazy var loadFeedLabel:UILabel = {
        let label = UILabel()
        label.text = "\u{2022} Faster loading feed"
        label.textColor = UIColor.black
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    lazy var purchaseBtn:UIButton = {
        let button = UIButton()
        button.setTitle("Purchase", for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byClipping
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Bold", size: 23)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        let spacing: CGFloat = 8.0
        button.layer.borderColor = UIColor.blue.cgColor
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        button.addTarget(self, action: #selector(goToPurchase), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(noAds)
        view.addSubview(adFreeLabel)
        view.addSubview(loadFeedLabel)
        view.addSubview(purchaseBtn)
        noAdsConstraints()
        adFreeLabelConstraints()
        loadFeedLabelConstraints()
        purchaseBtnConstraints()
        
    }
    
    @objc func goToPurchase() {
        let purchaseVC = IAPMasterViewController()
        navigationController?.pushViewController(purchaseVC, animated: true)
    }
    
    func noAdsConstraints() {
           noAds.translatesAutoresizingMaskIntoConstraints = false
           noAds.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           noAds.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
       }
    
    func adFreeLabelConstraints() {
           adFreeLabel.translatesAutoresizingMaskIntoConstraints = false
           adFreeLabel.leadingAnchor.constraint(equalTo: noAds.leadingAnchor).isActive = true
           adFreeLabel.topAnchor.constraint(equalTo: noAds.bottomAnchor, constant: 25).isActive = true
           
       }
    
    func loadFeedLabelConstraints() {
           loadFeedLabel.translatesAutoresizingMaskIntoConstraints = false
           loadFeedLabel.leadingAnchor.constraint(equalTo: noAds.leadingAnchor).isActive = true
           loadFeedLabel.topAnchor.constraint(equalTo: adFreeLabel.bottomAnchor, constant: 24).isActive = true
           
       }
    
    func purchaseBtnConstraints() {
        purchaseBtn.translatesAutoresizingMaskIntoConstraints = false
        purchaseBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        purchaseBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        purchaseBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        purchaseBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        
    }
    
    
    
    
    
    
}


