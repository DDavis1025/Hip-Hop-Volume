//
//  ImageToServer.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/14/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class ImageToServer {
    
    var finished:Bool?

 func imageUploadRequest(imageView: UIImageView, uploadUrl: URL, param: [String:String]?, completion: @escaping () -> ()) {

        var request = URLRequest(url: uploadUrl)
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = imageView.image!.jpegData(compressionQuality: 1)

        if(imageData==nil)  { return; }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data

        //myActivityIndicator.startAnimating();

             let task =  URLSession.shared.dataTask(with: request){
                (data, response, error) -> Void in
                if let data = data {

                    // You can print out response object
                    print("******* response = \(response)")

                    print(data.count)
                    // you can use data here

                    // Print out reponse body
                    let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("****** response data = \(responseString!)")

                    let json =  try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary

                    print("json value \(json)")

                    //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)

                    completion()
                    
                    DispatchQueue.main.async {
                        //self.myActivityIndicator.stopAnimating()
                        //self.imageView.image = nil;
                    }
                } else if let error = error {
                    print(error)
                }
        }
        task.resume()


    }


    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();

        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }

        let filename = "user-profile.jpg"

        let mimetype = "image/jpg"

        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")

        body.appendString(string: "--\(boundary)--\r\n")

        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}

// extension for impage uploading

extension NSMutableData {

    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
