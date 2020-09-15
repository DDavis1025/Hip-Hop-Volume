//
//  FollowUsers.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/4/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

struct FollowTitle {
    var follow_title:String
    
    func updateFollowTitle(newString: Bool) {
        ModelClass.self.playing = newString
    }
}

class FollowUsers: Toolbar, UITableViewDelegate, UITableViewDataSource {
    private var myTableView: UITableView!
    
    var users: [UsersModel]?
    var followTitle:String?
    var imageLoader:DownloadImage?
    init(users: [UsersModel]?) {
        self.users = users
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        addTableView()
        view.backgroundColor = UIColor.white
    }

    
    
    func addTableView() {
        
        self.myTableView = UITableView()
        
        
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.myTableView.frame.size.height = self.view.frame.height
        self.myTableView.frame.size.width = self.view.frame.width
        
        
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.isScrollEnabled = true
        
        myTableView.delaysContentTouches = false
        self.view.addSubview(self.myTableView)
        
        self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true

        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        myTableView.layoutMargins = UIEdgeInsets.zero
        myTableView.separatorInset = UIEdgeInsets.zero
        
                    
                    

       

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let artistPFVC = ArtistProfileVC()
        artistPFVC.artistID = users?[indexPath.row].user_id
        navigationController?.pushViewController(artistPFVC, animated: true)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        let itemSize = CGSize.init(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image?.draw(in: imageRect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.layoutMargins = UIEdgeInsets.zero
        cell.textLabel!.text = users?[indexPath.row].username ?? "undefined"
        self.imageLoader = DownloadImage()
           imageLoader?.imageDidSet = { [weak self] image in
            cell.imageView?.image = image
            }
        imageLoader?.downloadImage(urlString: users![indexPath.row].picture!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return followTitle
    }

   

    
}

