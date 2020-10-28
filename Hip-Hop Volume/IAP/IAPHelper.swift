//
//  IAPHelper.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 9/4/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
  static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject  {
    private var productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    public init(productIds: Set<ProductIdentifier>) {
      productIdentifiers = productIds
      super.init()
//        for productIdentifier in productIdentifiers {
//          if let user_id = profile?.sub {
//              GETPurchase(user_id: user_id, productIdentifier: productIdentifier).getPurchase(completion: {
//                  if $0.count > 0 {
//                  self.purchasedProductIdentifiers.insert(productIdentifier)
//                  print("Previously purchased: \(productIdentifier)")
//                  } else {
//                  print("Not purchased: \(productIdentifier)")
//                  }
//                 })
//           }
//       }
      SKPaymentQueue.default().add(self)
    }
    
}

// MARK: - StoreKit API

extension IAPHelper {
  
  public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }
    
  public func buyProduct(_ product: SKProduct) {
    print("Buying \(product.productIdentifier)...")
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }

//  public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
//    return purchasedProductIdentifiers.contains(productIdentifier)
//  }
    
//    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
//        return IsPurchased.isPurchased
//      }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
  
  public func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
    
  func addPurchaseUser(user_id: String, productIdentifier:String) {
    let purchase = Purchase(user_id: user_id, productIdentifier: productIdentifier)
    
    AddPurchase(endpoint: "purchase").save(purchase, completion: {
        (result) in
            switch result {
            case .success(let receipt):
                print("Success saving user purchase")
            case .failure(let error):
                print("An error occurred \(error)")
            }
    })
  }
}


extension IAPHelper: SKProductsRequestDelegate {

  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    print("Loaded list of products...")
    let products = response.products
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()

    for p in products {
        print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
    }
  }
  
  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of products.")
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

extension IAPHelper: SKPaymentTransactionObserver {
 
  public func paymentQueue(_ queue: SKPaymentQueue,
                           updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch transaction.transactionState {
      case .purchased:
        complete(transaction: transaction)
        break
      case .failed:
        fail(transaction: transaction)
        break
      case .restored:
        restore(transaction: transaction)
        break
      case .deferred:
        break
      case .purchasing:
        break
      }
    }
  }
 
  private func complete(transaction: SKPaymentTransaction) {
    print("complete...")
    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
 
    print("restore... \(productIdentifier)")
    deliverPurchaseNotificationFor(identifier: productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func fail(transaction: SKPaymentTransaction) {
    print("fail...")
    if let transactionError = transaction.error as NSError?,
      let localizedDescription = transaction.error?.localizedDescription,
        transactionError.code != SKError.paymentCancelled.rawValue {
        print("Transaction Error: \(localizedDescription)")
      }

    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func deliverPurchaseNotificationFor(identifier: String?) {
    print("indentifier \(identifier)")
    guard let identifier = identifier else { return }
    print("got indentifier \(identifier)")
//    purchasedProductIdentifiers.insert(identifier)
    let profile = SessionManager.shared.profile
    if let user_id = profile?.sub {
    print("user found \(user_id)")
    addPurchaseUser(user_id: user_id, productIdentifier: identifier)
    } else {
        print("user not found")
    }
    let purchase = IsPremiumPurchased()
    purchase.updateIsPurchased(newBool: true)
//    UserDefaults.standard.set(true, forKey: identifier)
    NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
  }
}
