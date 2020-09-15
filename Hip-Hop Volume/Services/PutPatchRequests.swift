//
//  PutPatchRequests.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/15/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

class UpdateUserInfo {
    
    func updateUserInfo(parameters:[String:String], user_id: String, completion: @escaping () -> ()) {
        guard let accessToken = AccessToken.accessToken else {
            return
        }
        let headers = [
            "authorization": "Bearer \(accessToken)",
            "content-type": "application/json"
        ]
        print("parameters \(parameters)")
//        let parameters = ["user_metadata": ["addresses": ["home": "123 Main Street, Anytown, ST 12345"]]] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dev-owihjaep.auth0.com"
        components.path = "/api/v2/users/\(user_id)"
        
        print("components user patch \(components.url)")
        
        let request = NSMutableURLRequest(url: NSURL(string: components.url!.absoluteString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
            DispatchQueue.main.async {
                completion()
            }
        })
        
        dataTask.resume()
    }
}

struct UpdateUser {
    let resourceURL:URL
    
    init(endpoint:String) {
        let resourceString = "http://localhost:8000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save(_ commentToSave: UsersModel2, completion: @escaping(Result<[UsersModel2], APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(commentToSave)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                do {
                    let userData = try JSONDecoder().decode([UsersModel2].self, from: jsonData)
                    completion(.success(userData))
                } catch {
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
}
