//
//  ArtistAlbumsCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/10/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

struct ArtistStruct {
    static var artistID:String?
    
    func updateArtistID(newString: String) {
        ArtistStruct.self.artistID = newString
    }
}

class ArtistAlbumsCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    static let shared = ArtistAlbumsCell()
    var artistID:String?
    var myTableView: UITableView!
    var parent:ArtistPFContainerView?
    var imageLoader:DownloadImage?
    var imageLoaded:Bool? = false
    var refresher:UIRefreshControl?
    var artistData = [ArtistModel]() {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
            self.spinnerView.removeFromSuperview()
            self.spinner.stopAnimating()
        }
    }
    var post:Post? {
        didSet {
            let vc = AlbumVC(post: self.post!)
            parent?.navigationController?.pushViewController(vc, animated: true)
            print("posty \(post)")
        }
    }
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        
        return component
    }()
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let spinnerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSpinner()
        addTableView()

        print("Artist ID \(artistID)")
        if let artistID = ArtistStruct.artistID {
        self.getArtist(id: artistID)
        }
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        myTableView.addSubview(refresher!)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func refresh() {
        if let artist_id = ArtistStruct.artistID {
           let getArtistById =  GETArtistById(id: artist_id)
           getArtistById.getAllById {
               self.artistData = $0
               self.refresher?.endRefreshing()
           }
        }
    }
    
    func addSpinner() {
           spinnerView.backgroundColor = UIColor.white
           
           self.addSubview(spinnerView)
    
           spinnerView.translatesAutoresizingMaskIntoConstraints = false
           
           spinnerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
           spinnerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
           
           spinnerView.addSubview(spinner)
           spinner.translatesAutoresizingMaskIntoConstraints = false
           spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor).isActive = true
           spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor).isActive = true
           spinner.startAnimating()
           spinner.hidesWhenStopped = true
       }
    
    func addTableView() {
        self.myTableView = UITableView()
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.myTableView.dataSource = self
        self.myTableView.delegate = self

        addSubview(self.myTableView)
        
        print("tbl view")

        myTableView.delaysContentTouches = false
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.myTableView?.topAnchor.constraint(equalTo: topAnchor).isActive = true

        self.myTableView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        self.myTableView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        self.myTableView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            myTableView.layoutMargins = UIEdgeInsets.zero
            myTableView.separatorInset = UIEdgeInsets.zero
            
        }
    
    func getAlbum(id: String) {
        GETAlbum(id: id).getPostsById() {
            self.post = $0
        }
    }

    func getArtist(id: String) {
        let getArtistById =  GETArtistById(id: id)
        getArtistById.getAllById {
            self.artistData = $0
        }
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return artistData.count
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            getAlbum(id: artistData[indexPath.row].id!)
        
    }
        

         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                      
                      let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
                       cell.textLabel!.text = "\(artistData[indexPath.row].title!)"
                       components.path = "/\(artistData[indexPath.row].path!)"
                         
                       cell.imageView!.image = UIImage(named: "music-placeholder")

                      let itemSize = CGSize.init(width: 100, height: 100)
                      UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                      let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                      cell.imageView?.image!.draw(in: imageRect)
                      cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                      UIGraphicsEndImageContext();
                      cell.translatesAutoresizingMaskIntoConstraints = false
                      cell.layoutMargins = UIEdgeInsets.zero
                      
                       self.imageLoader = DownloadImage()
                        if let url = self.components.url?.absoluteString {
                        imageLoader?.imageDidSet = { [weak self] image in
                        
                        cell.imageView!.image = image
                            let itemSize = CGSize.init(width: 100, height: 100)
                            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                            cell.imageView?.image!.draw(in: imageRect)
                            cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                            UIGraphicsEndImageContext();
                       }
                       self.imageLoader?.downloadImage(urlString: url)
                      }
                      return cell
                  }
    
    
}
