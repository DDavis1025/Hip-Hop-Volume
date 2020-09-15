import Foundation
import UIKit
import GoogleMobileAds

class TracksCell: AlbumCell {
         override init(frame: CGRect) {
           super.init(frame: frame)
   //        addSpinner()
//            spinner.startAnimating()
//            addTableView()
//            GetAllOfMediaType(path:"tracks").getAllPosts {
//                       self.posts = $0
//                       self.myTableView.reloadData()
//                   }
//
//           refresher = UIRefreshControl()
//           refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
//           refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//           addSpinner()
//
//           myTableView.addSubview(refresher!)
       }
    
    override func addMainMethods() {
        addTableView()
        GetAllOfMediaType(path:"tracks").getAllPosts {
                   self.posts = $0
            print("track posts \(self.posts)")
//                   self.myTableView.reloadData()
               }
        
        refresher = UIRefreshControl()
        refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        addTableView()
        myTableView.addSubview(refresher!)
        addSpinner()
        adSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc override func refresh() {
        GetAllOfMediaType(path:"tracks").getAllPosts {
                self.refresher?.endRefreshing()
                self.fromRefresh = true
                self.posts = $0
                self.addNativeAds()
                self.myTableView.reloadData()
                self.myTableView?.beginUpdates()
                self.myTableView?.endUpdates()

        }
        
    }
    
    override func addTableView() {
    super.addTableView()
           
        self.myTableView.register(FeedCell.self, forCellReuseIdentifier: "MyCell")
           
            
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            print("didSelect TrackCell row")
           if let post = mainArray[indexPath.row] as? Post {
            if let id = post.id {
             if let path = post.title {
                if let author_id = post.author {
              let trackVC = TrackPlayVC()
              let author = Author()
              trackVC.captureId(id: id)
              trackVC.trackName = path
//              trackVC.author_id = author_id
              trackVC.justClicked = true
              let trackPlay = TrackPlay()
              trackPlay.updateAuthorID(newString: author_id)
              author.updateAuthorID(newString: author_id)
              let modalVC = UINavigationController(rootViewController: trackVC)
              modalVC.modalPresentationStyle = .fullScreen

              parent?.navigationController?.present(modalVC, animated: true, completion: nil)
            }
           }
         }
       }
    }
    

    
    

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! FeedCell
//
//        let post = posts[indexPath.row]
//
//        cell.set(post: post)
//
//        cell.setUser(user: userDictionary[posts[indexPath.row].author!])
//
//
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

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

}


