//
//  AdTest.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/21/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import AVFoundation

class AdMobView: GADUnifiedNativeAdView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
////        backgroundColor = UIColor(red: 254.0/255, green: 255.0/255, blue: 232.0/255, alpha: 1.0)
//        backgroundColor = UIColor.black
        setupViews()
        addSubview(adLabel)
//        addSubview(adChoicesImage)
//        adMobMediaViewConstraints()
        iconViewConstraints()
        headlineViewConstraints()
        advertiserViewConstraints()
        starRatingViewConstraints()
        bodyViewConstraints()
        callToActionBtnConstraints()
        storeViewConstraints()
        priceViewConstraints()
        adLabelConstraints()
//        adChoicesLogoConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let adMobMediaView: GADMediaView = {
           let mediaView = GADMediaView()
           mediaView.translatesAutoresizingMaskIntoConstraints = false
           return mediaView
       }()
    
    var adLabel:UILabel = {
        let label = UILabel()
        label.text = "Ad"
        label.font = label.font.withSize(15)
        label.sizeToFit()
        label.backgroundColor = UIColor(red: 247.0/255, green: 213.0/255, blue: 101.0/255, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    var theHeadlineView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = label.font.withSize(16)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var theAdvertiserView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    var bodyLabel:UILabel = {
        let label = UILabel()
        
        label.sizeToFit()
        return label
    }()
    
//    lazy var bodyView:UITextView = {
//        let tv = UITextView()
//        tv.isScrollEnabled = false
//        tv.isEditable = false
//        tv.sizeToFit()
//        tv.backgroundColor = UIColor.gray
//        tv.textContainer.maximumNumberOfLines = 4
//        tv.textContainer.lineBreakMode = .byCharWrapping
//        tv.font = UIFont(name: "GillSans", size: 18)
//        return tv
//    }()
    
    var theBodyView:UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15.2)
        label.sizeToFit()
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var theStoreView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    var thePriceView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()
    
    lazy var adChoicesImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GoogleAdChoicesIcon")
        return imageView
    }()
    
    lazy var theIconView:UIImageView = {
        let image = UIImageView()
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.borderWidth = 0.5
        return image
    }()
    
//    lazy var theStarRatingView:UIImageView = {
//        let image = UIImageView()
//        return image
//    }()
   lazy var theStarRatingView:UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    lazy var theCallToActionView:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor(red: 20.0/255, green: 137.0/255, blue: 255.0/255, alpha: 1.0), for: .normal)
        btn.sizeToFit()
        return btn
    }()
    
    func adMobMediaViewConstraints() {
        guard let bodyView = bodyView else {
            return
        }
        mediaView?.translatesAutoresizingMaskIntoConstraints = false
        mediaView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        mediaView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        mediaView?.topAnchor.constraint(equalTo: bodyView.bottomAnchor).isActive = true
    }
    
    func adLabelConstraints() {
        adLabel.translatesAutoresizingMaskIntoConstraints = false
        adLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
        adLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        adLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        adLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
//    func adChoicesLogoConstraints() {
//        adChoicesImage.translatesAutoresizingMaskIntoConstraints = false
//        adChoicesImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        adChoicesImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        adChoicesImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
//        adChoicesImage.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
//    }
    
    func iconViewConstraints() {
        iconView?.translatesAutoresizingMaskIntoConstraints = false
        iconView?.widthAnchor.constraint(equalToConstant: 90).isActive = true
        iconView?.heightAnchor.constraint(equalToConstant: 90).isActive = true
        iconView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        iconView?.topAnchor.constraint(equalTo: adLabel.bottomAnchor, constant: 10).isActive = true
        iconView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    func headlineViewConstraints() {
        guard let iconView = iconView else {
            return
        }
        guard let advertiserView = advertiserView else {
            return
        }
        headlineView?.translatesAutoresizingMaskIntoConstraints = false
        headlineView?.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10).isActive = true
        headlineView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        
//        headlineView?.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
        headlineView?.topAnchor.constraint(equalTo: advertiserView.bottomAnchor, constant: 1.7).isActive = true
    }
    
    func advertiserViewConstraints() {
        advertiserView?.translatesAutoresizingMaskIntoConstraints = false
        guard let iconView = iconView else {
            return
        }
        advertiserView?.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10).isActive = true
        advertiserView?.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
//        advertiserView?.bottomAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true
//        advertiserView?.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
    }
    
    func starRatingViewConstraints() {
        guard let headlineView = headlineView else {
            return
        }
        guard let callToActionView = callToActionView else {
            return
        }
        starRatingView?.translatesAutoresizingMaskIntoConstraints = false
        starRatingView?.leadingAnchor.constraint(equalTo: headlineView.leadingAnchor).isActive = true
        starRatingView?.centerYAnchor.constraint(equalTo: callToActionView.centerYAnchor).isActive = true
    }
    
    func bodyViewConstraints() {
        guard let iconView = iconView else {
            return
        }
        bodyView?.translatesAutoresizingMaskIntoConstraints = false
        bodyView?.leadingAnchor.constraint(equalTo: iconView.leadingAnchor).isActive = true
        bodyView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        bodyView?.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 17).isActive = true
        bodyView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9).isActive = true
    }
    
    func callToActionBtnConstraints() {
        guard let starRatingView = starRatingView else {
            return
        }
//        guard let iconView = iconView else {
//                   return
//               }
        guard let headlineView = headlineView else {
            return
        }
        callToActionView?.translatesAutoresizingMaskIntoConstraints = false
        callToActionView?.leadingAnchor.constraint(equalTo: starRatingView.trailingAnchor).isActive = true
//        callToActionView?.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        callToActionView?.topAnchor.constraint(equalTo: headlineView.bottomAnchor, constant: 5).isActive = true
    }
    
    func storeViewConstraints() {
        storeView?.translatesAutoresizingMaskIntoConstraints = false
        guard let callToActionView = callToActionView else {
            return
        }
        storeView?.trailingAnchor.constraint(equalTo: callToActionView.leadingAnchor, constant: 5).isActive = true
        storeView?.centerYAnchor.constraint(equalTo: callToActionView.centerYAnchor).isActive = true
    }
    
    func priceViewConstraints() {
        guard let storeView = storeView else {
            return
        }
        guard let callToActionView = callToActionView else {
            return
        }
        priceView?.translatesAutoresizingMaskIntoConstraints = false
        priceView?.trailingAnchor.constraint(equalTo: storeView.leadingAnchor, constant: 5).isActive = true
        priceView?.centerYAnchor.constraint(equalTo: callToActionView.centerYAnchor).isActive = true
    }
    
    
    func setupViews() {
        mediaView = adMobMediaView
        iconView = theIconView
        headlineView = theHeadlineView
        callToActionView = theCallToActionView
        bodyView = theBodyView
        priceView = thePriceView
        storeView = theStoreView
        advertiserView = theAdvertiserView
        starRatingView = theStarRatingView
        

//        if let mediaView = mediaView {
//            addSubview(mediaView)
//        }
        if let iconView = iconView {
        addSubview(iconView)
        }
        if let headlineView = headlineView {
        addSubview(headlineView)
        }
        if let callToActionView = callToActionView {
        addSubview(callToActionView)
        }
        if let bodyView = bodyView {
        addSubview(bodyView)
        }
        if let priceView = priceView {
        addSubview(priceView)
        }
        if let storeView = storeView {
        addSubview(storeView)
        }
        if let advertiserView = advertiserView {
        addSubview(advertiserView)
        }
        if let starRatingView = starRatingView {
        addSubview(starRatingView)
        }
    
    }
    
    
    
}


class AdCell: UITableViewCell {
    
    var adMobView:AdMobView?
    
    let mainView: AdMobView = {
        let view = AdMobView()
        view.backgroundColor = UIColor(red: 252.0/255, green: 251.0/255, blue: 242.0/255, alpha: 1.0)
        view.sizeToFit()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none

        addSubview(mainView)

        mainView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        mainView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//        mainView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        mainView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdItems(nativeAd: GADUnifiedNativeAd) {
        print("adItems didSet \(nativeAd.headline)")
        // Associate the ad view with the ad object.
        // This is required to make the ad clickable.
        mainView.nativeAd = nativeAd

        // Populate the ad view with the ad assets.
        
        (mainView.iconView as! UIImageView).image = nativeAd.icon?.image ?? UIImage(named: "noimageshown")
        (mainView.headlineView as! UILabel).text = nativeAd.headline
        (mainView.priceView as! UILabel).text = nativeAd.price
        if let starRating = nativeAd.starRating {
          (mainView.starRatingView as! UILabel).text =
              starRating.description + "\u{2605}"
        } else {
          (mainView.starRatingView as! UILabel).text = nil
        }
        (mainView.bodyView as! UILabel).text = nativeAd.body
        (mainView.advertiserView as! UILabel).text = nativeAd.advertiser
        // The SDK automatically turns off user interaction for assets that are part of the ad, but
        // it is still good to be explicit.
        (mainView.callToActionView as! UIButton).isUserInteractionEnabled = false
        (mainView.callToActionView as! UIButton).setTitle(
            nativeAd.callToAction, for: UIControl.State.normal)
    }
}
