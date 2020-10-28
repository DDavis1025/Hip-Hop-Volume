//
//  IAPMasterViewController.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 9/4/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit
import StoreKit

class IAPMasterViewController: UITableViewController {
  
  let showDetailSegueIdentifier = "showDetail"
  
  var products: [SKProduct] = []
    
  var restoreButton:UIBarButtonItem?
  
//  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//    if identifier == showDetailSegueIdentifier {
//      guard let indexPath = tableView.indexPathForSelectedRow else {
//        return false
//      }
//
//      let product = products[indexPath.row]
//
//      return HipHopVolumeProducts.store.isProductPurchased(product.productIdentifier)
//    }
//
//    return true
//  }
//
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == showDetailSegueIdentifier {
//      guard let indexPath = tableView.indexPathForSelectedRow else { return }
//
//      let product = products[indexPath.row]
//
//      if let name = resourceNameForProductIdentifier(product.productIdentifier),
//             let detailViewController = segue.destination as? DetailViewController {
//        let image = UIImage(named: name)
//        detailViewController.image = image
//      }
//    }
//  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = false
    
    title = "Purchases"
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(IAPMasterViewController.reload), for: .valueChanged)
    
    restoreButton = UIBarButtonItem(title: "Restore",
                                        style: .plain,
                                        target: self,
                                        action: #selector(IAPMasterViewController.restoreTapped(_:)))
    
    if !IsPremiumPurchased.isPurchased {
    navigationItem.rightBarButtonItem = restoreButton
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(logoutAfterPurchase),
                                           name: .IAPHelperPurchaseNotification,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(IAPMasterViewController.handlePurchaseNotification(_:)),
                                           name: .IAPHelperPurchaseNotification,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(IAPMasterViewController.handlePurchaseNotification(_:)),
                                           name: .IAPHelperPurchaseNotification,
                                           object: nil)
    
    
    self.tableView.register(ProductCell.self, forCellReuseIdentifier: "Cell")
  }
    
    func receiptValidator() {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                print("receiptData \(receiptData)")

                let receiptString = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
                
                print("receiptString \(receiptString)")
                
                let receipt = Receipt(receipt: receiptString)
                
                ReceiptValidation(endpoint: "verifyReceipt").postNow(receipt, completion: {
                    (result) in
                        switch result {
                        case .success(let receipt):
                            print("Success posting receipt")
                        case .failure(let error):
                            print("An error occurred \(error)")
                        }
                })
                // Read receiptData
            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
        }
        
    
}
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    receiptValidator()
    reload()
    var profile = SessionManager.shared.profile
    print("profile sub iapmaster \(profile!.sub)")
  }
  
  @objc func reload() {
    products = []
    
    tableView.reloadData()

    
    HipHopVolumeProducts.store.requestProducts{ [weak self] success, products in
      guard let self = self else { return }
      if success {
        self.products = products!
        
        print("products home \(products)")
        DispatchQueue.main.async {
         self.tableView.reloadData()
        }
    
      }
      DispatchQueue.main.async {
       self.refreshControl?.endRefreshing()
     }
    }
  }
    
    @objc func logoutAfterPurchase() {
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = false }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first


        let authVC = UINavigationController(rootViewController: AuthVC())

        keyWindow?.rootViewController = authVC
        self.navigationController?.popToRootViewController(animated: true)
            
        print("logoutAfterPurchase worked \(keyWindow?.rootViewController)")
          
       }
    }
  
  @objc func restoreTapped(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Alert", message: "You can only restore purchases if you have purchased this item with this apple id, if so you will be logged out", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        HipHopVolumeProducts.store.restorePurchases()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        alert.dismiss(animated: true, completion: nil)
    }))
        self.present(alert, animated: true, completion: nil)
  }

  @objc func handlePurchaseNotification(_ notification: Notification) {
    guard
      let productID = notification.object as? String,
        let index = products.firstIndex(where: { product -> Bool in
        product.productIdentifier == productID
      })
    else { return }
    
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    
    restoreButton?.isEnabled = false
    
  }
    
    func productCellDelegateFunction() {
        let indexPath = NSIndexPath(item: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! ProductCell
        
        
        let alert = UIAlertController(title: "Alert", message: "You will be logged out once you complete your purchase", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            cell.buyFunction()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
            self.present(alert, animated: true, completion: nil)
      }
        
}

// MARK: - UITableViewDataSource

extension IAPMasterViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCell


    let product = products[indexPath.row]
    
    cell.product = product
    cell.delegate = self
    cell.buyButtonHandler = { product in
      HipHopVolumeProducts.store.buyProduct(product)
    }
    
    return cell
  }
}

extension IAPMasterViewController: ProductCellDelegate {
    func buyAlert() {
        productCellDelegateFunction()
    }
    
}
