//
//  ImageDownloader.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Combine

class ImageDownloader: ObservableObject {
    var imageCache = NSCache<AnyObject, AnyObject>()
    var imageDidSet: ((UIImage) -> ())?
    var dataTask: URLSessionDataTask?
    var imageDidLoad: ((UIImage) -> ())?
    var imageURL:String? = ""
    
    init(imageURL: String?) {
        self.imageURL = imageURL
    }
    
    var image:UIImage? {
         didSet {
            imageDidSet?(image!)
          }
    }
    

    func load() {
        
        if let cacheImage = self.imageCache.object(forKey: self.imageURL as AnyObject) as? UIImage {
                self.image = cacheImage
                print("cached image \(cacheImage)")
                return
            }

        guard let imageURL = self.imageURL else { return }
        guard let url = URL(string: imageURL) else { return }
        
            
        
       dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Couldn't download image: ", error)
                    return
                }
                
                guard let data = data else { return }
              
           if let image = UIImage(data: data) {
            self.imageCache.setObject(image, forKey: self.imageURL as AnyObject)
                
                DispatchQueue.main.async {
                    self.image = image
                }
        }
          
        }
        dataTask?.resume()

    }
}


