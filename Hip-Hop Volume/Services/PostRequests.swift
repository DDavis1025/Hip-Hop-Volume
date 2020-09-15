//
//  PostRequests.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/1/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

enum APIError:Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct FollowerPostRequest {
    let resourceURL:URL
    
    init(endpoint:String) {
        let resourceString = "http://localhost:8000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save(_ followerToSave:Follower, completion: @escaping(Result<Follower, APIError>) -> Void) {
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(followerToSave)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                do {
                    let followerData = try JSONDecoder().decode(Follower.self, from: jsonData)
                    completion(.success(followerData))
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

struct CommentPostRequest {
    let resourceURL:URL
    
    init(endpoint:String) {
        let resourceString = "http://localhost:8000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
        print("comment POST URL \(self.resourceURL)")
    }
    
    func save(_ commentToSave: Comment, completion: @escaping(Result<[Comment], APIError>) -> Void) {
        
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
                    let commentData = try JSONDecoder().decode([Comment].self, from: jsonData)
                    completion(.success(commentData))
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


struct CommentLikePostRequest {
    let resourceURL:URL
    
    init(endpoint:String) {
        let resourceString = "http://localhost:8000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save(_ commentToSave: CommentLike, completion: @escaping(Result<[CommentLike], APIError>) -> Void) {
        
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
                    let commentLikeData = try JSONDecoder().decode([CommentLike].self, from: jsonData)
                    completion(.success(commentLikeData))
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


struct SubCommentLikePostRequest {
    let resourceURL:URL
    
    init(endpoint:String) {
        let resourceString = "http://localhost:8000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save(_ subCommentLikeToSave: SubCommentLike, completion: @escaping(Result<[SubCommentLike], APIError>) -> Void) {
        print("sub Comment isLiked url \(self.resourceURL)")
        
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(subCommentLikeToSave)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                do {
                    let subCommentLikeData = try JSONDecoder().decode([SubCommentLike].self, from: jsonData)
                    completion(.success(subCommentLikeData))
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



struct CommentsPostRequest {
    let resourceURL:URL
    
    init(endpoint:String) {
        let resourceString = "http://localhost:8000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save(_ commentToSave: Comments, completion: @escaping(Result<[Comments], APIError>) -> Void) {
        
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
                    let commentData = try JSONDecoder().decode([Comments].self, from: jsonData)
                    completion(.success(commentData))
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




struct LikeRequest {
    let resourceURL:URL
    
    init(endpoint:String) {
        let resourceString = "http://localhost:8000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save(_ commentToSave: LikeModel, completion: @escaping(Result<[LikeModel], APIError>) -> Void) {
        
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
                    let likeData = try JSONDecoder().decode([LikeModel].self, from: jsonData)
                    completion(.success(likeData))
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

class Auth0AccessToken {
    func getAccessToken(completion: @escaping ([ManagementAccessToken]) -> ()) {
    let headers = ["content-type": "application/x-www-form-urlencoded"]

    let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)
    postData.append("&client_id=1xSs0Ez95mih823mzKFxHWVDFh7iHX8y".data(using: String.Encoding.utf8)!)
    postData.append("&client_secret=-v6XTncUAYsx_Pzdlsh8p0sxaZidx8FD2wTh0g4TP-3QVgWkTd0ewqZg4CBauDIN".data(using: String.Encoding.utf8)!)
    postData.append("&audience=https://dev-owihjaep.auth0.com/api/v2/".data(using: String.Encoding.utf8)!)

    let request = NSMutableURLRequest(url: NSURL(string: "https://dev-owihjaep.auth0.com/oauth/token")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData as Data

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if let error = error {
                  print("Error \(error)")
                  return
              }
              guard let data = data else {
                  return
              }
              guard let responseData = try? JSONDecoder().decode(ManagementAccessToken.self, from: data) else {
                  print("Unable to decode data \(data)")
                  return
                }
                 
                  DispatchQueue.main.async {
                      print("responseData \(responseData)")
                      completion([responseData])
                  }
          })

          dataTask.resume()
}



struct POSTAuth0 {
    func post(completion: @escaping(()->())) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "dev-owihjaep.auth0.com"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
           URLQueryItem(name: "grant_type", value: "client_credentials"),
           URLQueryItem(name: "client_id", value: "1xSs0Ez95mih823mzKFxHWVDFh7iHX8y"),
           URLQueryItem(name: "client_secret", value: "-v6XTncUAYsx_Pzdlsh8p0sxaZidx8FD2wTh0g4TP-3QVgWkTd0ewqZg4CBauDIN"),
           URLQueryItem(name: "audience", value: "https://dillonsapi.com")
        ]
        
            var urlRequest = URLRequest(url: urlComponents.url!)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = headers
        
            print("urlRequest \(urlRequest)")
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                   if (error != nil) {
                     print(error)
                   } else {
                     let httpResponse = response as? HTTPURLResponse
                     print("httpResponse \(httpResponse)")
                     if let httpResponse = httpResponse {
                         
                     }
                   }

            }.resume()
       }
    }
}

