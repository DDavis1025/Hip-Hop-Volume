//
//  UpgradeToPremium.swift
//  Hip-Hop Volume
//
//  Created by Dillon Davis on 10/28/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class UpgradeToPremium: Toolbar {
    
    lazy var premium:UILabel = {
        let label = UILabel()
        label.text = "Premium"
        label.textColor = UIColor.black
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 80)
        return label
    }()
    
    lazy var adFreeLabel:UILabel = {
        let label = UILabel()
        label.text = "\u{2022} Ad-free content and listening"
        label.textColor = UIColor.black
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    lazy var dataUsage:UILabel = {
        let label = UILabel()
        label.text = "\u{2022} 80GB of upload data (A regular 1 hour video is about 0.25GB)"
        label.textColor = UIColor.black
        label.numberOfLines = 3
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    lazy var visitSite:UILabel = {
        let label = UILabel()
        label.text = "Visit www.hiphopvolume.com on a desktop to subscribe"
        label.textColor = UIColor.black
        label.numberOfLines = 3
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    lazy var cancelSub:UILabel = {
        let label = UILabel()
        label.text = "Subscribed. Visit www.hiphopvolume.com on a desktop to cancel"
        label.textColor = UIColor.black
        label.numberOfLines = 3
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    lazy var purchaseBtn:UIButton = {
        let button = UIButton()
        button.setTitle("Upgrade", for: .normal)
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
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor.white
        view.addSubview(premium)
        view.addSubview(adFreeLabel)
        view.addSubview(dataUsage)
        if !IsPremiumPurchased.isPurchased {
        view.addSubview(visitSite)
        visitSiteLabelConstraints()
        } else {
        view.addSubview(cancelSub)
        cancelSubLabelConstraints()
        }
//        view.addSubview(purchaseBtn)
        premiumConstraints()
        adFreeLabelConstraints()
        dataUsageLabelConstraints()
//        visitSiteLabelConstraints()
//        cancelSubLabelConstraints()
//        purchaseBtnConstraints()
        edgesForExtendedLayout = []
    }
    
    @objc func goToPurchase() {
        let purchaseVC = IAPMasterViewController()
        navigationController?.pushViewController(purchaseVC, animated: true)
    }
    
    func premiumConstraints() {
           premium.translatesAutoresizingMaskIntoConstraints = false
//           premium.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           premium.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
           premium.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
           premium.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
       }
    
    func dataUsageLabelConstraints() {
        dataUsage.translatesAutoresizingMaskIntoConstraints = false
        dataUsage.leadingAnchor.constraint(equalTo: premium.leadingAnchor).isActive = true
        dataUsage.trailingAnchor.constraint(equalTo: premium.trailingAnchor).isActive = true
        dataUsage.topAnchor.constraint(equalTo: premium.bottomAnchor, constant: 25).isActive = true
//        dataUsage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
           
       }
    func adFreeLabelConstraints() {
        adFreeLabel.translatesAutoresizingMaskIntoConstraints = false
        adFreeLabel.leadingAnchor.constraint(equalTo: premium.leadingAnchor).isActive = true
        adFreeLabel.topAnchor.constraint(equalTo: dataUsage.bottomAnchor, constant: 24).isActive = true
        adFreeLabel.trailingAnchor.constraint(equalTo: premium.trailingAnchor).isActive = true
//        adFreeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
           
       }
    
    func visitSiteLabelConstraints() {
        visitSite.translatesAutoresizingMaskIntoConstraints = false
        visitSite.leadingAnchor.constraint(equalTo: premium.leadingAnchor).isActive = true
        visitSite.topAnchor.constraint(equalTo: adFreeLabel.bottomAnchor, constant: 50).isActive = true
        visitSite.trailingAnchor.constraint(equalTo: premium.trailingAnchor).isActive = true
//        visitSite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
           
       }
    
    
    func cancelSubLabelConstraints() {
        cancelSub.translatesAutoresizingMaskIntoConstraints = false
        cancelSub.leadingAnchor.constraint(equalTo: premium.leadingAnchor).isActive = true
        cancelSub.topAnchor.constraint(equalTo: adFreeLabel.bottomAnchor, constant: 50).isActive = true
        cancelSub.trailingAnchor.constraint(equalTo: premium.trailingAnchor).isActive = true
//        visitSite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
           
       }
    
    func purchaseBtnConstraints() {
        purchaseBtn.translatesAutoresizingMaskIntoConstraints = false
        purchaseBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        purchaseBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        purchaseBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        purchaseBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        
    }
    
    
    
    
    
    
}



