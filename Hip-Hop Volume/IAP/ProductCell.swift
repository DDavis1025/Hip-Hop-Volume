//
//  ProductCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 9/4/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit
import StoreKit

protocol ProductCellDelegate:class {
    func buyAlert()
}

class ProductCell: UITableViewCell {
  weak var delegate: ProductCellDelegate?
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    
    return formatter
  }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  var buyButtonHandler: ((_ product: SKProduct) -> Void)?
  
  var product: SKProduct? {
    didSet {
      guard let product = product else { return }
        
      print("detailTextLabel \(detailTextLabel)")
     
      textLabel?.text = product.localizedTitle
     
      if IsPurchased.isPurchased {
        accessoryType = .checkmark
        accessoryView = nil
        detailTextLabel?.text = ""
        print("isPurchased")
      } else if IAPHelper.canMakePayments() {
        ProductCell.priceFormatter.locale = product.priceLocale
        detailTextLabel?.text = ProductCell.priceFormatter.string(from: product.price)
        print("\(ProductCell.priceFormatter.string(from: product.price)) product now")
     
        accessoryType = .none
        accessoryView = self.newBuyButton()
      } else {
        detailTextLabel?.text = "Not available"
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    textLabel?.text = ""
    detailTextLabel?.text = ""
    accessoryView = nil
  }
  
  func newBuyButton() -> UIButton {
    let button = UIButton(type: .system)
    button.setTitleColor(tintColor, for: .normal)
    button.setTitle("Buy", for: .normal)
    button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), for: .touchUpInside)
    button.sizeToFit()
    
    return button
  }
    
   func buyFunction() {
     buyButtonHandler?(product!)
   }

  
  @objc func buyButtonTapped(_ sender: AnyObject) {
    delegate?.buyAlert()
//    buyButtonHandler?(product!)
  }
}

