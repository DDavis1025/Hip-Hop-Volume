//
//  GoToUpload.swift
//  Hip-Hop Volume
//
//  Created by Dillon Davis on 10/1/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class GoToUpload: UIViewController {
    
    lazy var goToUpload:UILabel = {
        let label = UILabel()
        label.text = "To Upload an album, track, or video visit \"www.hiphopvolume.com\" on your desktop"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor.white
        view.addSubview(goToUpload)
        goToUploadConstraints()
        
    }
    
    @objc func goToPurchase() {
        let purchaseVC = IAPMasterViewController()
        navigationController?.pushViewController(purchaseVC, animated: true)
    }
    
    func goToUploadConstraints() {
        goToUpload.translatesAutoresizingMaskIntoConstraints = false
//        goToUpload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goToUpload.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29).isActive = true
//        goToUpload.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.70).isActive = true
        goToUpload.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        goToUpload.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
       }
    
    
    
    
    
}

