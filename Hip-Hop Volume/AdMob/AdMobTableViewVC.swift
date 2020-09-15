//
//  AdMobTableViewVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/26/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation

class AdMobVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GADUnifiedNativeAdLoaderDelegate {
    private var myTableView:UITableView!
    
    var arrayItems:[Any] = []
    var adLoader: GADAdLoader!
    var nativeAds = [GADUnifiedNativeAd]()
    
    override func viewDidLoad() {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 5

        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
            adTypes: [GADAdLoaderAdType.unifiedNative],
            options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
        view.backgroundColor = UIColor.white
        addTableView()
        addArray()
    }
    
    func addItem() {
        for n in 1...20 {
            arrayItems.append(n)
        }
    }
    
    func addArray() {
        addItem()
        myTableView.reloadData()
    }
    
    func addTableView() {

        self.myTableView = UITableView()


        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.myTableView.register(AdCell.self, forCellReuseIdentifier: "AdCell")

        self.myTableView.frame.size.height = self.view.frame.height
        //
        self.myTableView.frame.size.width = self.view.frame.width
        
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.isScrollEnabled = true

        self.view.addSubview(self.myTableView)


        self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true

        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.myTableView.estimatedRowHeight = 100
        self.myTableView.rowHeight = UITableView.automaticDimension


        myTableView.layoutMargins = UIEdgeInsets.zero
        myTableView.separatorInset = UIEdgeInsets.zero


    }

    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
         nativeAds.append(nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    }
    
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
      addNativeAds()
        myTableView.reloadData()
        self.myTableView?.beginUpdates()
        self.myTableView?.endUpdates()
    }
    
    func addNativeAds() {
      if nativeAds.count <= 0 {
        return
      }

      let adInterval = (arrayItems.count / nativeAds.count) + 1
      var index = 0
      for nativeAd in nativeAds {
        if index < arrayItems.count {
          arrayItems.insert(nativeAd, at: index)
          index += adInterval
        } else {
          break
        }
      }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayItems.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let menuItem = arrayItems[indexPath.row] as? Int {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
            cell.textLabel?.text = "\(arrayItems[indexPath.row])"
            return cell
        
      } else {
        let nativeAd = arrayItems[indexPath.row] as! GADUnifiedNativeAd
        /// Set the native ad's rootViewController to the current view controller.
        nativeAd.rootViewController = self

        let nativeAdCell =  tableView.dequeueReusableCell(withIdentifier: "AdCell") as! AdCell
        
        nativeAdCell.addAdItems(nativeAd: nativeAd)

        // Get the ad view from the Cell. The view hierarchy for this cell is defined in
        // UnifiedNativeAdCell.xib.
//        let adView : GADUnifiedNativeAdView = nativeAdCell.contentView.subviews
//          .first as! GADUnifiedNativeAdView

//        // Associate the ad view with the ad object.
//        // This is required to make the ad clickable.
//        adView.nativeAd = nativeAd
//
//        // Populate the ad view with the ad assets.
//        (adView.headlineView as! UILabel).text = nativeAd.headline
//        (adView.priceView as! UILabel).text = nativeAd.price
//        if let starRating = nativeAd.starRating {
//          (adView.starRatingView as! UILabel).text =
//              starRating.description + "\u{2605}"
//        } else {
//          (adView.starRatingView as! UILabel).text = nil
//        }
//        (adView.bodyView as! UILabel).text = nativeAd.body
//        (adView.advertiserView as! UILabel).text = nativeAd.advertiser
//        // The SDK automatically turns off user interaction for assets that are part of the ad, but
//        // it is still good to be explicit.
//        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//        (adView.callToActionView as! UIButton).setTitle(
//            nativeAd.callToAction, for: UIControl.State.normal)

        return nativeAdCell
      }
    }

}

