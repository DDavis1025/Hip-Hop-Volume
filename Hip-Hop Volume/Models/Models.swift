//
//  Post.swift
//  Test
//
//  Created by Dillon Davis on 2/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import SwiftUI

struct Post: Codable, Hashable, Identifiable {
    
    let id: String?
    let title: String?
    let path: String
    let description: String?
    let author: String?
    var userName:String?
    
    mutating func addUser(user: String) {
        userName = user
    }
}


struct PostById: Codable, Hashable, Identifiable {
    
    
    let id:String?
    let user_id:String?
    let title:String?
    let album_id:String?
    let name: String?
    let path: String?
    let author:String?
    let description:String?
    let type:String?
    
}

struct User: Codable, Hashable, Identifiable {
    let id:String?
    let username:String?
    let picture:String?
}

struct UsersModel: Codable {
    var name:String?
    var username:String?
    var picture:String?
    var user_id:String?
    var email:String?
}

struct UsersModel2: Codable {
    var name:String?
    var username:String?
    var picture:String?
    var user_id:String?
    var email:String?
    
    init(username: String, user_id: String) {
        self.username = username
        self.user_id = user_id
    }
}

final class Follower: Codable {
    var user_id:String?
    var follower_id:String?
    var follower_username:String?
    var follower_picture:String?
    
    init(user_id:String, follower_id:String, follower_username:String, follower_picture:String) {
        self.user_id = user_id
        self.follower_id = follower_id
        self.follower_username = follower_username
        self.follower_picture = follower_picture
    }
}

struct Following: Codable, Hashable {
    var user_id:String?
    
}

struct Follows: Codable, Hashable {
    var follower_id:String?
    
}

struct Follow: Codable, Hashable {
    var user_id:String?
    var follower_id:String?
    
}


struct ImageModel: Codable {
    var data:Data?
}



class ModelClass : NSObject
{
    static var trackNameLabel:String?
    static var track:String?
    static var post_id:String?
    static var isLiked:Bool? = false
    static var listArray:[PostById]? = []
    static var index:Int?
    static var imgPath:String?
    static var post:Post?
    static var playing:Bool? = false
    static var theViewLoaded:Bool? = false
    static var justClicked:Bool? = false
    static var clickedFromAT:Bool? = false
    static var user_id:String?
    static var viewAppeared:Bool? = false
    
    func updatePlaying(newBool: Bool) {
           ModelClass.self.playing = newBool
       }
    
    func updateTrackNameLabel(newText: String) {
        ModelClass.self.trackNameLabel = newText
    }
    
    func updatePostID(newString: String) {
        ModelClass.self.post_id = newString
    }
    
    func updateTrackPath(newText: String) {
        ModelClass.self.track = newText
    }
    
    func updateUserID(newString: String) {
        ModelClass.self.user_id = newString
    }
    
    func updateIsLiked(newBool: Bool) {
        ModelClass.self.isLiked = newBool
    }
    
    func updateListArray(newList: [PostById]?) {
        ModelClass.self.listArray = newList
    }
    
    func updateIndex(newInt: Int) {
        ModelClass.self.index = newInt
    }
    
    func updateImgPath(newText: String) {
        ModelClass.self.imgPath = newText
    }
    
    func updatePost(newPost: Post) {
        ModelClass.self.post = newPost
    }
    
    func updateTheViewLoaded(newBool: Bool) {
        ModelClass.self.theViewLoaded = newBool
    }
    
    func updateJustClicked(newBool: Bool) {
        ModelClass.self.justClicked = newBool
    }
    
    func updateClickedFromAT(newBool: Bool) {
        ModelClass.self.clickedFromAT = newBool
    }
    
    func updateViewAppeared(newBool: Bool) {
        ModelClass.self.viewAppeared = newBool
    }
}
 

struct ArtistModel: Codable {
    var title:String?
    var author:String?
    var description:String?
    var id:String?
    var path:String?
}

struct UserPhoto: Codable {
    var path:String?
}


struct Email:Codable {
    var email:String?
}

struct Username:Codable {
    var username:String?
}

struct MediaPath:Codable {
    var path:String?
}

struct Author {
    static var author_id:String?
    
    func updateAuthorID(newString: String) {
        Author.self.author_id = newString
    }
}


final class Comment: Codable {
    var id:String?
    var post_id:String?
    var username:String?
    var user_picture:String?
    var user_id:String?
    var post_user_id:String?
    var text:String?
    var parent_id:String?
    var comment_userID:String?
    var tableview_index:Int?
    var parentsubcommentid:String?
    
    init(post_id:String, username:String, user_picture:String, user_id:String, text:String, parent_id: String?, comment_userID:String?, tableview_index:Int?, parentsubcommentid:String?, post_user_id:String?) {
        self.post_id = post_id
        self.username = username
        self.user_picture = user_picture
        self.user_id = user_id
        self.text = text
        self.parent_id = parent_id
        self.comment_userID = comment_userID
        self.tableview_index = tableview_index
        self.parentsubcommentid = parentsubcommentid
        self.post_user_id = post_user_id
    }
}

struct Comments: Codable {
    var id:String?
    var post_id:String?
    var text:String?
    var username:String?
    var user_picture:String?
    var user_id:String?
    var parent_id:String?
    var isliked:Bool?
    var numberOfLikes:Int?
    var likes:Int?
    var tableview_index:Int?
    var parentsubcommentid:String?
}

final class CommentLike: Codable {
    var user_id:String?
    var username:String?
    var user_picture:String?
    var comment_id:String?
    var post_id:String?
    var comment_userID:String?
    var tableview_index:String?
    var parent_id:String?
    
    init(user_id:String, username:String, user_picture:String, comment_id:String, post_id:String, comment_userID:String, tableview_index:String, parent_id:String?) {
        self.user_id = user_id
        self.comment_id = comment_id
        self.post_id = post_id
        self.comment_userID = comment_userID
        self.tableview_index = tableview_index
        if let parent_id = parent_id {
        self.parent_id = parent_id
        }
        self.username = username
        self.user_picture = user_picture
    }
}

struct UserAndComment: Codable {
    var user_id:String?
    var comment_id:String?
}

struct CommentLikes: Codable {
    var user_id:String?
    var likes:String?
}

final class SubCommentLike: Codable {
    var isLiked:Bool?
    
    init(isLiked:Bool) {
        self.isLiked = isLiked
    }
}


struct Notifications: Codable {
    var user_id:String?
    var supporter_id:String?
    var supporter_username:String?
    var supporter_picture:String?
    var message:String?
    var post_id:String?
    var parent_commentid:String?
    var comment_id:String?
    var parentsubcommentid:String?
    var parent_comment:String?
    var post_image:String?
    var post_type:String?
    var new:Bool?
}

struct PostImage:Codable {
    var path:String?
    var type:String?
}

struct Song:Codable {
    var album_id:String?
    var name:String?
    var index:Int?
    var id:String?
    var title:String?
    var author:String?
    var path:String?
}

final class LikeModel: Codable {
    var user_id:String?
    var supporter_id:String?
    var supporter_username:String?
    var supporter_picture:String?
    var post_id:String?
    var post_type:String?
    
    init(user_id:String, supporter_id:String, supporter_username:String?, supporter_picture:String?, post_id:String, post_type:String) {
        self.user_id = user_id
        self.supporter_id = supporter_id
        if let supporter_username = supporter_username {
         self.supporter_username = supporter_username
        }
        if let supporter_picture = supporter_picture {
         self.supporter_picture = supporter_picture
        }
        self.post_id = post_id
        self.post_type = post_type
        
    }
}

struct NumberOfNext {
    static var numberOfNext:Int = 0
    
    func updateNumberOfNext(newInt:Int) {
        NumberOfNext.self.numberOfNext = newInt
    }
}

struct ManagementAccessToken: Decodable {
    var access_token:String
}






