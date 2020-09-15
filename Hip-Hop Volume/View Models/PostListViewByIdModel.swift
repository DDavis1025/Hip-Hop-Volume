//
//  PostListViewByIdModel.swift
//  Test
//
//  Created by Dillon Davis on 3/18/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class PostListViewByIdModel: ObservableObject {
    
    @ObservedObject var model = PostListViewModel()
    
    init() {
       fetchPostsById()
     }

    
    @Published var postsById = [PostById]()
    
    private func fetchPostsById() {
           for post in model.posts {
            SecondWebService(id: post.id).getAllPostsById {
           self.postsById = $0
           print("ALL THAT \($0)")
               
        }

 }

}

}
