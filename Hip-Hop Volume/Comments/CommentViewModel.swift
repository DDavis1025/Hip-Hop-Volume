import UIKit
import Foundation

class CommentViewModel {
    var profile = SessionManager.shared.profile
    var offset: Int = 0
    static var offsetForCell: Int = 0
    var buttonTag:[Int] = []
    static var parent_id:String?
    var mainComment: Comments? {
        didSet {
            if let likes = mainComment?.likes {
             commentLikesCount = likes
            }
     }
    }
    var mainCommentImage: UIImage?
    var commentLikes:Int?
    var commentLikesDidInserts: ((Int) -> ())?
    var subComments: [Comments] = []
    var subCommentDidInserts: (([Comments]) -> ())?
    var imageDownloader: DownloadImage?
    var symbolConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
    var likeBtnImage: UIImage? = UIImage(systemName: "heart")  { didSet { likeBtnImageDidSet?(likeBtnImage) } }
    var likeBtnImageDidSet: ((UIImage?)->())?
    var likeBtnTintColor: UIColor? = UIColor.darkGray { didSet { likeBtnTintColorDidSet?(likeBtnTintColor) } }
    var likeBtnTintColorDidSet: ((UIColor?)->())?
    var isLiked: Bool = false
    var isLikedLoaded: Bool = false
    var commentsExist:Bool?
    var commentsExistDidInserts: ((Bool) -> ())?
    var repliesExist:Bool?
    var repliesExistDidInserts: ((Bool) -> ())?
    var notification_commentID:String?
    var notification_parentSubId:String?
//    var checkedReplies:Bool? = Bool(".isHidden")
//    var repliesBtn: UIButton? = UIButton()  { didSet { repliesBtnDidSet?(repliesBtn) } }
//    var repliesBtnDidSet: ((UIButton?)->())?
//    var viewMoreBtn: UIButton?  { didSet { viewMoreBtnDidSet?(viewMoreBtn) } }
//    var viewMoreBtnDidSet: ((UIButton?)->())?
    var viewMoreBtnState: Bool? = false { didSet { viewMoreBtnStateDidSet?(viewMoreBtnState) } }
    var viewMoreBtnStateDidSet: ((Bool?)->())?
    var repliesBtnState: Bool? = true { didSet { repliesBtnStateDidSet?(repliesBtnState) } }
    var repliesBtnStateDidSet: ((Bool?)->())?
    var notCheckedExists:Bool? = true
    var offset2:Int = 0
    var dltBtnIsHidden:Bool?
    var dltBtnIsHiddenDidSet: ((Bool?)->())?
    var dltBtnIsEnabled:Bool?
    var dltBtnIsEnabledDidSet: ((Bool?)->())?
    var commentLikesLoaded:Bool = false
    var notCheckedCommentBelongs:Bool? = true
    var subCommentDeleteIsHidden:Bool?
    var subCommentDeleteIsHiddenDidSet: ((Bool?)->())?
    var notCheckedSubDeleteExists:Bool? = true
    var commentLikesCount: Int? { didSet {  commentLikesCountDidSet?( commentLikesCount) } }
    var commentLikesCountDidSet: ((Int?)->())?

    
    
    func viewMore(id:String) {
        loadSubComments()
        let offset2 = offset + 3
        commentsExist(comment_id: id, offset: "\(offset2)", completion: { comment in
            if comment.count <= 0 {
                self.viewMoreBtnState = true
            } else {
                self.viewMoreBtnState = false
            }
        })
        offset += 3
    }
   
    func reply(id:String) {
        offset = 0
        loadSubComments()
        let offset2 = offset + 3
        commentsExist(comment_id: id, offset: "\(offset2)", completion: { comment in
            if comment.count <= 0 {
                self.viewMoreBtnState = true
            } else {
                self.viewMoreBtnState = false
            }
        })
        offset += 3
    }
    
    func viewRepliesExists(comment_id:String, notificationParentId:String?) {
        commentsExist(comment_id: comment_id, offset: "0", completion: { comment in
            self.notCheckedExists = false
            if let notiParentId = notificationParentId {
                print("notiParentId \(notiParentId)")
                let subCommentsFiltered:[Comments] = comment.filter {
                    return $0.parent_id != notiParentId
                }
                if subCommentsFiltered.count > 0 {
                    print("subCommentsFiltered.count > 0")
                    self.repliesBtnState = false
                } else {
                    self.repliesBtnState = true
                }
            } else {
            print("self.repliesBtn.isHidden sub notchecked \(self.notCheckedExists)")
            self.notCheckedExists = false
            if comment.count > 0 {
                self.repliesBtnState = false
            } else {
                self.repliesBtnState = true
            }
            print("self.repliesBtn.isHidden sub viewReplies")
          }
        })
    }
    
   
    func loadSubComments() {
        print("loadSubComments")
        let getSubComments = GETSubComments(id: CommentViewModel.parent_id, path: "subComments", offset: "\(offset)")
            getSubComments.getAllById {
                if let comment_id = self.notification_commentID, let parentSubId = self.notification_parentSubId {
                    let subCommentAfterFilter:[Comments] = $0.filter {
                        $0.id != comment_id && $0.id != parentSubId
                    }
                    self.subComments += subCommentAfterFilter
                    self.subCommentDidInserts?(subCommentAfterFilter)
//                    self.notification_commentID = nil
//                    self.notification_parentSubId = nil
                    
                } else if let comment_id = self.notification_commentID {
                    let subCommentAfterFilter:[Comments] = $0.filter {
                        $0.id != comment_id
                    }
                    self.subComments += subCommentAfterFilter
                    self.subCommentDidInserts?(subCommentAfterFilter)
//                    self.notification_commentID = nil
                    
                } else {
                   self.subComments += $0
                   self.subCommentDidInserts?($0)
                }
        }
    }
    
    func commentsExist(comment_id: String, offset: String, completion: @escaping ([Comments]) -> ()) {
        let getSubComments = GETSubComments(id: comment_id, path: "subComments", offset: "\(offset)")
            getSubComments.getAllById {
            completion($0)
        }
    }
    
    func loadSubCommentsAfterReply(comment_id:String?, user_id:String?) {
        print("loadSubCommentsAfterReply")
        if let id = comment_id {
            let getSubComments = GETSubCommentAfterReply(id: id, user_id: user_id)
            
            getSubComments.getSubComment {
                self.subComments += $0
                self.subCommentDidInserts?($0)
                let offset2 = self.offset + 1
                print("offset this \(self.offset)")
                if let id = comment_id {
                    self.commentsExist(comment_id: id, offset: "\(offset2)", completion: { comment in
                        print("comment this loadSubCommentsAfterReply \(comment)")
                        if comment.count <= 0 {
                            self.viewMoreBtnState = true
                        } else {
                            self.viewMoreBtnState = false
                        }
                    })
                }
                
                self.offset += 1
                
            }
        }
    }
    
    func loadCommentLikes(id:String) {
        print("loadCommentLikes")
        let getCommentLikes = GETCommentLikes(id: id)
        getCommentLikes.getAllById {
            self.commentLikes = $0.count
            self.commentLikesDidInserts?($0.count)
            self.commentLikesLoaded = true
        }
    }
    
    func getCommentLikesBuIserId(comment_id:String, user_id:String) {
           guard isLikedLoaded == false else { return }
           
          let getLikeByUser = GETCommentLikesByUserID(comment_id: comment_id, user_id: user_id)
           
           getLikeByUser.getAllById {
               if $0.count > 0 {
               self.likeBtnImage = UIImage(systemName: "heart.fill")
               self.likeBtnTintColor = .red
            
                self.isLiked = true
                self.isLikedLoaded = true
               } else {
                self.likeBtnImage = UIImage(systemName: "heart")
                self.likeBtnTintColor = .darkGray
            }
       }
    }
    
    func likeComment(user_id: String, username: String, user_picture:String, comment_id: String, post_id: String, comment_userID:String, index:String) {
        let commentLike = CommentLike(user_id: user_id, username: username, user_picture: user_picture, comment_id: comment_id, post_id: post_id, comment_userID: comment_userID, tableview_index: index, parent_id: nil)
               
               
               let postRequest = CommentLikePostRequest(endpoint: "addCommentLike")
               postRequest.save(commentLike) { (result) in
                   switch result {
                   case .success(let comment):
                       print("the following comment like has been sent: \(commentLike)")
                       GETCommentsRequest(id: comment_id, path: "getCommentLikes").getAllById(completion: {
                        print("hello $0 \($0)")
                        if let likes = $0[0].likes {
                            print("got likes \($0[0].likes)")
                            self.commentLikesCount = likes
                        } else {
                            print("didn't get likes \($0[0].likes)")
                        }
                       })
//                       self.loadCommentLikes(id: comment_id)
                   case .failure(let error):
                       print("An error occurred: \(error)")
                   }
               }
            self.likeBtnImage = UIImage(systemName: "heart.fill")
            self.likeBtnTintColor = .red
            self.isLiked = true
    }
    
    func unlikeComment(comment_id: String, user_id: String) {
       let deleteRequest = DLTCommentLike(comment_id: comment_id, user_id: user_id)
        
        deleteRequest.delete {(err) in
            if let err = err {
                print("Failed to delete", err)
                return
            }
            GETCommentsRequest(id: comment_id, path: "getCommentLikes").getAllById(completion: {
             if let likes = $0[0].likes {
                 self.mainComment?.likes = likes
             }
            })
            self.loadCommentLikes(id: comment_id)
            print("Successfully deleted comment like from server")
            }
            self.likeBtnImage = UIImage(systemName: "heart")
            self.likeBtnTintColor = .darkGray
            self.isLiked = false
    }
    
    
    func getSubCommentLikesByIserId(comment_id:String, user_id:String, completion: @escaping (Bool) -> ()) {
          print("it worked")
          let getLikeByUser = GETCommentLikesByUserID(comment_id: comment_id, user_id: user_id)
           
           getLikeByUser.getAllById {
               if $0.count > 0 {
               completion(true)
            } else {
               completion(false)
          }
       }
    }
    
    func likeSubComment(user_id: String, username: String, user_picture:String, comment_id: String, post_id:String, comment_userID: String, index: String, parent_id:String,  completion: @escaping () -> ()) {
        let commentLike = CommentLike(user_id: user_id, username: username, user_picture: user_picture, comment_id: comment_id, post_id: post_id, comment_userID: comment_userID, tableview_index: index, parent_id: parent_id)
        
        let postRequest = CommentLikePostRequest(endpoint: "addCommentLike")
        postRequest.save(commentLike) { (result) in
            switch result {
            case .success(let comment):
                print("the following sub comment like has been sent: \(commentLike)")
                completion()
            //                       self.loadCommentLikes(id: comment_id)
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }
    
    
    func unlikeSubComment(comment_id: String, user_id: String, completion: @escaping () -> ()) {
       let deleteRequest = DLTCommentLike(comment_id: comment_id, user_id: user_id)
        
        deleteRequest.delete {(err) in
            if let err = err {
                print("Failed to delete", err)
                return
            }
//            self.loadCommentLikes(id: comment_id)
            completion()
            print("Successfully deleted sub comment like from server")
            }
    }
    
    func loadSubCommentLikes(id:String, completion: @escaping ([CommentLikes]) -> ()) {
        print("loadSubCommentLikes")
        let getCommentLikes = GETCommentLikes(id: id)
        getCommentLikes.getAllById {
             completion($0)
        }
    }
    
    func addNotificationSubComment(subComment: [Comments], parent_id:String) {
        subComments += subComment
        self.subCommentDidInserts?(subComment)
        notification_commentID = subComment[0].id
        if let id = subComment[0].id {
            self.commentsExist(comment_id: parent_id, offset: "0", completion: { comment in
                let commentsAfterFilter:[Comments] = comment.filter {
                    return $0.id != id
                }
                if commentsAfterFilter.count <= 0 {
                    print("commentsAfterFilter.count <= 0")
                    self.viewMoreBtnState = true
                } else {
                    print("commentsAfterFilter.count >= 0")
                    self.viewMoreBtnState = false
                }
            })
        } else {
            print("subComment[0].id \(subComment[0].id) + parent_id \(CommentViewModel.parent_id)")
        }
        
        print("addNotificationSubComment")
    }
    
    func addNotificationParentSubAndReply(subComment: [Comments], parentSubComment:[Comments], parent_id:String) {
        subComments += parentSubComment
        self.subCommentDidInserts?(parentSubComment)
        subComments += subComment
        self.subCommentDidInserts?(subComment)
        print("addNotificationParentSubAndReply sub comment \(subComment)")
        notification_commentID = subComment[0].id
        notification_parentSubId = parentSubComment[0].id
        if let id = subComment[0].id, let parentSubId = parentSubComment[0].id {
            self.commentsExist(comment_id: parent_id, offset: "0", completion: { comment in
                let commentsAfterFilter:[Comments] = comment.filter {
                    return $0.id != id && $0.id != parentSubId
                }
                if commentsAfterFilter.count <= 0 {
                    print("commentsAfterFilter.count <= 0")
                    self.viewMoreBtnState = true
                } else {
                    print("commentsAfterFilter.count >= 0")
                    self.viewMoreBtnState = false
                }
            })
        } else {
            print("subComment[0].id \(subComment[0].id) + parent_id \(CommentViewModel.parent_id)")
        }
        
        print("addNotificationSubComment")
    }
    
    func doesCommentBelongToUser(comment_id:String, user_id:String) {
        let getCommentByUser = GETCommentByUser(id: comment_id, user_id: user_id)
        getCommentByUser.getComments {
            self.notCheckedCommentBelongs = false
            if $0.count > 0 {
                self.dltBtnIsHidden = false
                self.dltBtnIsHiddenDidSet?(false)
                self.dltBtnIsEnabled = true
                self.dltBtnIsEnabledDidSet?(true)
              } else {
                self.dltBtnIsHidden = true
                self.dltBtnIsHiddenDidSet?(true)
                self.dltBtnIsEnabled = false
                self.dltBtnIsEnabledDidSet?(false)
            }
        }
    }
    
    func isSubDeleteHidden(comment_user_id:String, profile_id:String) {
        notCheckedSubDeleteExists = false
        if comment_user_id == profile_id {
            print("false isSubDelete \(comment_user_id) + \(profile_id)")
            self.subCommentDeleteIsHidden = false
            self.subCommentDeleteIsHiddenDidSet?(false)
        } else {
            print("true isSubDelete \(comment_user_id) + \(profile_id)")
            self.subCommentDeleteIsHidden = true
            self.subCommentDeleteIsHiddenDidSet?(true)
        }
    }
    
    
    
    func updateParentId(newString:String) {
        CommentViewModel.self.parent_id = newString
    }
    
    func updateOffsetForCell(newInt:Int) {
        CommentViewModel.self.offsetForCell = newInt
    }
    
//    func updateCommentsExist(newBool:Bool) {
//        CommentViewModel.self.commentsExist = newBool
//    }
    
}

