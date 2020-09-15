import Foundation
import UIKit
import GoogleMobileAds

struct VideoStruct {
    static var id:String?
    
    func updateVideoId(newString: String) {
        VideoStruct.self.id = newString
    }
}

class VideoCell: AlbumCell {
         override init(frame: CGRect) {
           super.init(frame: frame)
   //        addSpinner()
//            spinner.startAnimating()
//            addTableView()
//            GetAllOfMediaType(path:"videos").getAllPosts {
//             self.posts = $0
//            }
//
//           addSpinner()
//           refresher = UIRefreshControl()
//           refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
//           refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//
//
//           myTableView.addSubview(refresher!)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func addMainMethods() {
            addTableView()
            GetAllOfMediaType(path:"videos").getAllPosts {
             self.posts = $0
            }

            refresher = UIRefreshControl()
            refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)

            addTableView()
            myTableView.addSubview(refresher!)
            addSpinner()
            adSettings()
        }
    
    @objc override func refresh() {
        GetAllOfMediaType(path:"videos").getAllPosts {
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
           
        self.myTableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoTableViewCell")
           
            
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let videoStruct = VideoStruct()
            if let post = mainArray[indexPath.row] as? Post {
            if let id = post.id {
                print("posts[indexPath.row].id \(post.id)")
            videoStruct.updateVideoId(newString: id)
            if let video_id = VideoStruct.id {
            let videoVC = VideoVC()
            if let id = VideoStruct.id {
            videoVC.passId (id: id)
            }
            if let author = post.author {
              print("author now \(author)")
              videoVC.author = author
            }
            if let description = post.description {
              videoVC.video_description = description
            }
            if let title = post.title {
              videoVC.video_title = title
            }

            parent?.navigationController?.pushViewController(videoVC, animated: true)
            }

          }
       }
    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as! VideoTableViewCell
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
        print("video cell")
        if let post = mainArray[indexPath.row] as? Post {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as! VideoTableViewCell
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
