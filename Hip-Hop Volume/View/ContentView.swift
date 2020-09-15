//
//  ContentView.swift
//  Test
//
//  Created by Dillon Davis on 2/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import SwiftUI



struct ContentView: View {
  @ObservedObject var model = PostListViewModel()
  @ObservedObject var model2 = PostListViewByIdModel()
  static var shared = ContentView()
  var mainArray:[PostById] = []



        var body: some View {
            
          NavigationView {
                           List(model.posts) { post in
                             VStack{
                                   Text("Title: ").bold()
                                    + Text("\(post.title!)")
                                NavigationLink(destination: AlbumController(post:post)) {
                        
                                    ImageView(withURL: "http://localhost:8000/\(post.path.replacingOccurrences(of: " ", with: "%20"))")
                                   }
                                   Text("Description: ").bold()
                                    + Text("\(post.description!)")

                                   
                                 }
                            
        
                               }


                }
                    
                   
                        
//                  .onReceive(model.$posts) { posts in // << first got finished
//                     self.model2.fetchPostsById(for: posts)
//
//                   }
//
//                  .onReceive(model2.$postsById) { postById in
////                    print("Model2 \(postById)")
//                    ContentView.shared.mainArray.append(contentsOf: postById)
//                    
//                    }




}

    
}



