//
//  HipHopVolumeProducts.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 9/4/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

public struct HipHopVolumeProducts {
  
  public static let NoAds = "com.dillondavis.hiphopvolume.noads"
  
  private static let productIdentifiers: Set<ProductIdentifier> = [HipHopVolumeProducts.NoAds]

  public static let store = IAPHelper(productIds: HipHopVolumeProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}

