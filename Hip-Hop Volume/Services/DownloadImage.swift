//
//  DownloadImage.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/23/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//
import Foundation
import UIKit
import Combine

var imageCache = NSCache<AnyObject, AnyObject>()
class DownloadImage: ObservableObject {
//    var imageCache = NSCache<AnyObject, AnyObject>()
    var imageDidSet: ((UIImage) -> ())?
//    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var image:UIImage? {
         didSet {
            imageDidSet?(image!)
          }
    }
    


    func downloadImage(urlString: String) {
        
        
            if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                self.image = cacheImage
                print("cached image \(cacheImage)")
                return
            }

            guard let url = URL(string: urlString) else { return }
            
        
       dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Couldn't download image: ", error)
                    return
                }
                
                guard let data = data else { return }
              
           if let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: urlString as AnyObject)
                
                DispatchQueue.main.async {
                    self.image = image
                }
        }
          
        }
        dataTask?.resume()

        }
}

