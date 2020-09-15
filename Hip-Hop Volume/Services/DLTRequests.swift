//
//  DLTRequests.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/2/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

class DLTFollowingRequest {
    
    var user_id:String?
    var follower_id:String?
    init(user_id:String, follower_id:String) {
      self.user_id = user_id
      self.follower_id = follower_id
    }
    
    func delete(completion: @escaping(Error?) -> ()) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8000
        if let user_id = user_id, let follower_id = follower_id {
        components.path = "/following/\(user_id)/\(follower_id)"
        }
        
        guard let url = URL(string: components.url!.absoluteString) else {
            fatalError("URL is not correct!")
            
        }

        print("URL \(url)")
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                
                if let err = err {
                    completion(err)
                    return
                }
        
                completion(nil)
           
            }
            dataTask.resume()
    }
}


class DLTCommentLike {
    
    var comment_id:String?
    var user_id:String?
    init(comment_id:String, user_id:String) {
      self.comment_id = comment_id
      self.user_id = user_id
    }
    
    func delete(completion: @escaping(Error?) -> ()) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8000
        if let comment_id = comment_id, let user_id = user_id {
        components.path = "/deleteCommentLike/\(comment_id)/\(user_id)"
        }
        
        guard let url = URL(string: components.url!.absoluteString) else {
            fatalError("URL is not correct!")
            
        }

        print("URL \(url)")
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                
                if let err = err {
                    completion(err)
                    return
                }
        
                completion(nil)
           
            }
            dataTask.resume()
    }
}


class DLTComment {
    
    var comment_id:String?
    var user_id:String?
    var path:String?
    init(comment_id:String, user_id:String, path:String) {
      self.comment_id = comment_id
      self.user_id = user_id
      self.path = path
    }
    
    func delete(completion: @escaping(Error?) -> ()) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8000
        if let comment_id = comment_id, let user_id = user_id, let path = path {
        components.path = "/\(path)/\(comment_id)/\(user_id)"
        }
        
        guard let url = URL(string: components.url!.absoluteString) else {
            fatalError("URL is not correct!")
            
        }

        print("URL \(url)")
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                
                if let err = err {
                    completion(err)
                    return
                }
        
                completion(nil)
           
            }
            dataTask.resume()
    }
}


class DLTLike {
    
    var post_id:String?
    var supporter_id:String?
    init(post_id:String, supporter_id:String) {
      self.post_id = post_id
      self.supporter_id = supporter_id
    }
    
    func delete(completion: @escaping(Error?) -> ()) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8000
        if let post_id = post_id, let supporter_id = supporter_id {
        components.path = "/deletePostLike/\(post_id)/\(supporter_id)"
        }
        
        guard let url = URL(string: components.url!.absoluteString) else {
            fatalError("URL is not correct!")
            
        }

        print("URL \(url)")
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                
                if let err = err {
                    completion(err)
                    return
                }
        
                completion(nil)
           
            }
            dataTask.resume()
    }
}
