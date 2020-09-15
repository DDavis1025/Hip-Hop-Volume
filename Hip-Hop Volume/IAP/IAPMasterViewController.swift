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
    
    title = "Purchases"
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(IAPMasterViewController.reload), for: .valueChanged)
    
    let restoreButton = UIBarButtonItem(title: "Restore",
                                        style: .plain,
                                        target: self,
                                        action: #selector(IAPMasterViewController.restoreTapped(_:)))
    navigationItem.rightBarButtonItem = restoreButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(IAPMasterViewController.handlePurchaseNotification(_:)),
                                           name: .IAPHelperPurchaseNotification,
                                           object: nil)
    
    self.tableView.register(ProductCell.self, forCellReuseIdentifier: "Cell")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    reload()
  }
  
  @objc func reload() {
    products = []
    
    tableView.reloadData()
    
    HipHopVolumeProducts.store.requestProducts{ [weak self] success, products in
      guard let self = self else { return }
      if success {
        self.products = products!
        
        DispatchQueue.main.async {
         self.tableView.reloadData()
        }
    
      }
      DispatchQueue.main.async {
       self.refreshControl?.endRefreshing()
     }
    }
  }
  
  @objc func restoreTapped(_ sender: AnyObject) {
    HipHopVolumeProducts.store.restorePurchases()
  }

  @objc func handlePurchaseNotification(_ notification: Notification) {
    guard
      let productID = notification.object as? String,
      let index = products.index(where: { product -> Bool in
        product.productIdentifier == productID
      })
    else { return }
    
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
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
    cell.buyButtonHandler = { product in
      HipHopVolumeProducts.store.buyProduct(product)
    }
    
    return cell
  }
}
