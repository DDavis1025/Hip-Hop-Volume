//
//  AlbumsCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/6/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

protocol MyCollectionViewCellDelegate: class {
    func didPressTVCell()
}

struct AlbumsCellVM {
    static var offset:Int = 0
    
    func updateOffset(newInt:Int) {
        AlbumsCellVM.self.offset = newInt
    }
}
class AlbumCell: UICollectionViewCell, GADUnifiedNativeAdLoaderDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
       var myTableView: UITableView!
       private let apiCaller = APICaller()
       var mainArray:[Any] = [] 
       var adLoader: GADAdLoader!
       var nativeAds = [GADUnifiedNativeAd]()
       var parent:HomeViewController?
       var model:PostListViewModel?
       var child:SpinnerViewController?
       var cellTitle:UILabel?
       var cellDesc:UILabel?
       var usersLoaded:Bool? = false
       var getUserById:GetUsersById?
       var array = [String]()
       var fromRefresh:Bool = false
       var userDictionary = [String: UsersModel]()
       var users = [UsersModel]() {
           didSet {
               print("users should be array \(users)")

               let group = DispatchGroup()
               for user in users {
                   group.enter()
                   if let user_id = user.user_id {
                   userDictionary[user_id] = user
                   }
                   group.leave()
               }
               
               group.notify(queue: .main) {
                self.usersLoaded = true
                DispatchQueue.main.async {
//                self.myTableView.reloadData()
                }
//                self.spinner.stopAnimating()
//                self.view.removeFromSuperview()
//                self.refresher?.endRefreshing()
               }
               
               print("user dinctionary \(userDictionary)")

           }
       }
       var posts = [Post]() {
        didSet {
//            self.child?.willMove(toParent: nil)
//            self.child?.view.removeFromSuperview()
//            self.child?.removeFromParent()
            self.spinner.stopAnimating()
            self.view.removeFromSuperview()
            DispatchQueue.main.async {
                if self.fromRefresh == false {
                self.myTableView.reloadData()
                self.myTableView?.beginUpdates()
                self.myTableView?.endUpdates()
              }
            }
            
            print("posts right now \(posts)")
            
               func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
                   var buffer = [T]()
                   var added = Set<T>()
                   for elem in source {
                       if !added.contains(elem) {
                           buffer.append(elem)
                           added.insert(elem)
                       }
                   }
                   return buffer
               }
               
               var authorId = [String]()
               for post in self.posts {
                   authorId.append(post.author!)
               }
               
               
               let uniqueVals = uniq(source: authorId)
               print("unique vals \(uniqueVals)")
               
               for id in uniqueVals {
                       GetUsersById(id: id).getAllPosts {
                        var user = $0
                        if $0[0].username == nil {
                            GETUser(id: id, path: "getUserInfo").getAllById {
                                user[0].username = $0[0].username
                                self.users.append(contentsOf: user)
                            }
                        } else {
                        self.users.append(contentsOf: $0)
                           print("got users for this \($0)")
                    }
                 }
               }
            
            mainArray = posts
               
         }
       }
    
       var albumVC:AlbumVC?
       var imageLoader:DownloadImage?
       var refresher:UIRefreshControl?
       weak var delegate:MyCollectionViewCellDelegate?
       var offset:Int = 0
       
       var components:URLComponents = {
              var component = URLComponents()
              component.scheme = "https"
              component.host = "localhost"
              component.port = 8000
              return component
          }()
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let view = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addMainMethods()
//        Webservice().getAllPosts {
//                    self.posts = $0
//                }
//
//
//
//        refresher = UIRefreshControl()
//        refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//
//        addTableView()
//        myTableView.addSubview(refresher!)
//        addSpinner()
//        adSettings()
    }
    
    func addMainMethods() {
        addTableView()
        apiCaller.fetchData(pagination: false, offset: "\(0)", completion: { [self] in
            self.posts.append(contentsOf: $0)
//            adSettings()
//            self.posts = $0
        })
//        offset += 20
//        Webservice().getAllPosts {
//                    self.posts = $0
//                }
        
        refresher = UIRefreshControl()
        refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
//        addTableView()
        myTableView.addSubview(refresher!)
        addSpinner()
//        adSettings()
    }
    
    func adSettings() {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 5

        adLoader = GADAdLoader(adUnitID: "ca-app-pub-5763356067547990/7141730487", rootViewController: parent,
            adTypes: [GADAdLoaderAdType.unifiedNative],
            options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }

    
    @objc func refresh() {
//        APICaller(offset: "\(offset)").fetchData(pagination: <#T##Bool#>, completion: {
//            self.refresher?.endRefreshing()
//            self.fromRefresh = true
//            self.posts = $0
//            self.addNativeAds()
//            self.myTableView.reloadData()
//            self.myTableView?.beginUpdates()
//            self.myTableView?.endUpdates()
//        })
//        let albumVM = AlbumsCellVM()
//        let offset:Int = AlbumsCellVM.self.offset + 20
//        albumVM.updateOffset(newInt: offset)
//        Webservice().getAllPosts {
//            self.refresher?.endRefreshing()
//            self.fromRefresh = true
//            self.posts = $0
//            self.addNativeAds()
//            self.myTableView.reloadData()
//            self.myTableView?.beginUpdates()
//            self.myTableView?.endUpdates()
//        }
        
    }
    
    func addSpinner() {
        view.backgroundColor = UIColor.white

        self.addSubview(view)
        self.bringSubviewToFront(view)

        view.translatesAutoresizingMaskIntoConstraints = false

//        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        view.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true

        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
    }
//
//
//    func addSpinner() {
//             let child = SpinnerViewController()
//             addChild(child)
//             child.view.frame = view.frame
//             view.addSubview(child.view)
//             child.didMove(toParent: self)
//             child.view.backgroundColor = UIColor.white
//             self.view.bringSubviewToFront(child.view)
//       }
    
    
    
    
    
    func addTableView() {
        
            self.myTableView = UITableView()
                    
                    
            self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
                            
            self.myTableView.frame.size.height = self.frame.height
        //
            self.myTableView.frame.size.width = self.frame.width
                    
                            
            self.myTableView.register(FeedCell.self, forCellReuseIdentifier: "MyCell")
            self.myTableView.register(AdCell.self, forCellReuseIdentifier: "AdCell")
           
                            self.myTableView.dataSource = self
                            self.myTableView.delegate = self
                    
            myTableView.delaysContentTouches = false
            self.addSubview(self.myTableView)
            
            self.myTableView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.myTableView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

            self.myTableView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

           self.myTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
           self.myTableView.estimatedRowHeight = 100
           self.myTableView.rowHeight = UITableView.automaticDimension
        
        
            myTableView.layoutMargins = UIEdgeInsets.zero
            myTableView.separatorInset = UIEdgeInsets.zero
            
                    
                    

       

    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
         print("did recieve nativeAd \(nativeAd)")
         nativeAds.append(nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    }
    
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("self cell \(self)")
        addNativeAds(completion: {
            DispatchQueue.main.async {
              self.myTableView.tableFooterView = nil
            }
        })
//        DispatchQueue.main.async {
//          self.myTableView.tableFooterView = nil
//        }
        DispatchQueue.main.async {
        self.myTableView.reloadData()
        self.myTableView?.beginUpdates()
        self.myTableView?.endUpdates()
        self.spinner.stopAnimating()
        self.view.removeFromSuperview()
        self.refresher?.endRefreshing()
        }
//        DispatchQueue.main.async {
//          self.myTableView.tableFooterView = nil
//        }
//        self.child?.willMove(toParent: nil)
//        self.child?.view.removeFromSuperview()
//        self.child?.removeFromParent()
//        self.myTableView?.beginUpdates()
//        self.myTableView?.endUpdates()
    }
    
    func addNativeAds(completion: @escaping(()->())) {
      if nativeAds.count <= 0 {
        return
      }

      let adInterval = (mainArray.count / nativeAds.count) + 2
      var index = 0
      for nativeAd in nativeAds {
        print("nativeAd \(nativeAd)")
        if index < mainArray.count {
          mainArray.insert(nativeAd, at: index)
          index += adInterval
          completion()
        } else {
          break
        }
      }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//           return 140
//       }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        if let post = mainArray[indexPath.row] as? Post {
            let albumVC = AlbumVC(post: post)
            if let del = self.delegate {
               del.didPressTVCell()
            }
            parent?.navigationController?.pushViewController(albumVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
    }
    
    
    func tableView(_ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (!apiCaller.emptyData) {
            if indexPath.row == posts.count - 1 {
            if !apiCaller.isPaginating {
            self.myTableView.tableFooterView = createSpinnerFooter()
            offset += 20
            apiCaller.fetchData(pagination: true, offset: "\(offset)", completion: {
                self.posts.append(contentsOf: $0)
                print("self.mainArray.count \(self.mainArray.count)")
//                self.adSettings()
//              DispatchQueue.main.async {
//                 self.myTableView.tableFooterView = nil
//               }
            })
        }
      }
       } else {
            self.myTableView.tableFooterView = nil
        }
        

        if let post = mainArray[indexPath.row] as? Post {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! FeedCell
            let post = post
            
            cell.set(post: post)
            
            if let author = post.author {
            cell.setUser(user: userDictionary[author])
            }
            
            return cell
            
          } else {
            let nativeAd = mainArray[indexPath.row] as! GADUnifiedNativeAd
            /// Set the native ad's rootViewController to the current view controller.
            nativeAd.rootViewController = parent

            let nativeAdCell =  tableView.dequeueReusableCell(withIdentifier: "AdCell") as! AdCell

            nativeAdCell.addAdItems(nativeAd: nativeAd)

            return nativeAdCell
          }
        }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        
        spinner.startAnimating()
        
        return footerView
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        if (!apiCaller.emptyData) {
//        if position > (myTableView.contentSize.height-100-scrollView.frame.size.height) {
//            guard !apiCaller.isPaginating else {
//                // we are already fetching more data
//                print("we are already fetching more data")
//                return
//            }
//            self.myTableView.tableFooterView = createSpinnerFooter()
//            offset += 20
//            apiCaller.fetchData(pagination: true, offset: "\(offset)", completion: {
//                self.posts.append(contentsOf: $0)
//                print("self.mainArray.count \(self.mainArray.count)")
//                self.adSettings()
////               DispatchQueue.main.async {
////                 self.myTableView.tableFooterView = nil
////               }
//            })
//        }
//       } else {
//            self.myTableView.tableFooterView = nil
//        }
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//        // UITableView only moves in one direction, y axis
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//
//        // Change 10.0 to adjust the distance from bottom
//        if maximumOffset - currentOffset <= 10.0 {
//            if (!apiCaller.emptyData) {
//                guard !apiCaller.isPaginating else {
//                    // we are already fetching more data
//                    print("we are already fetching more data")
//                    return
//                }
//                self.myTableView.tableFooterView = createSpinnerFooter()
//                offset += 20
//                apiCaller.fetchData(pagination: true, offset: "\(offset)", completion: {
//                    self.posts.append(contentsOf: $0)
//                    print("self.mainArray.count \(self.mainArray.count)")
//                    self.adSettings()
//    //                DispatchQueue.main.async {
//    //                  self.myTableView.tableFooterView = nil
//    //                }
//                })
//           } else {
//                self.myTableView.tableFooterView = nil
//            }
//        }
//    }

    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

