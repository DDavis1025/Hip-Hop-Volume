//
//  CommentVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

struct CommentStruct {
    static var isSelected:Bool? = false
    static var subCommentReplySelected:Bool? = false
    static var parent_id:String?
    
    func updateIsSelected(newBool: Bool) {
        CommentStruct.self.isSelected = newBool
    }
    
    func updateParentId(newString: String) {
        CommentStruct.self.parent_id = newString
    }
    
    func updatesubReplyIsSelected(newBool: Bool) {
        CommentStruct.self.subCommentReplySelected = newBool
    }
    
}

protocol TableViewSubCommentDelegate {
    func didSendSubComment(parent_id:String)
}

protocol TableViewDelegate: class {
    func didSendSubComment()
}



class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UpdateTableView {
    func updateTableView(bool: Bool) {
         if bool == true {
//               self.myTableView.reloadData()
            UIView.performWithoutAnimation {
               self.myTableView.beginUpdates()
               self.myTableView.endUpdates()
            }
        }
    }
    
    
    private var myTableView:UITableView!
    var textField = UITextField()
    var bottomConstraint:NSLayoutConstraint?
    var profile = SessionManager.shared.profile
    var username:String?
    var imageLoader:DownloadImage?
    var comments:[CommentViewModel] = []
    var sub_comments:[CommentViewModel] = []
    var textViewHeight = CGFloat()
    let countLabel = UILabel()
    let textViewView = UIView()
    let sendBtn = UIButton()
    var tap: UITapGestureRecognizer?
    let comment = CommentStruct()
    var parent_id:String?
    var reply:Bool = false
    var subReply:Bool = false
    var delegate:TableViewSubCommentDelegate?
    weak var delegate2:TableViewDelegate?
    var usernameReply:String?
    var index:Int?
    var notificationIndex:Int?
    var replyingCommentCell: CommentCell?
    var comment_userID:String?
    var post_id:String?
    var notificationParentId:String?
    var notificationSubComments:[Comments] = []
    var notificationParentSubComment:[Comments]?
    var indexPath:IndexPath?
    var subCommentParentId:String?
    var parentSubCommentId:String?
    var subReplyUserId:String?
    var post_user_id:String?
    var notificationType:String?
    var post_comment_id:String?
    
    lazy var textView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.text = "Enter Comment"
        tv.textColor = UIColor.lightGray
        tv.sizeToFit()
        tv.returnKeyType = UIReturnKeyType.default
        tv.layer.cornerRadius = 4
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 0.5
        tv.keyboardType = UIKeyboardType.default
        tv.backgroundColor = UIColor.white
        tv.textContainer.maximumNumberOfLines = 0
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.font = UIFont(name: "GillSans", size: 18)
        return tv
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationController?.isToolbarHidden = true
        self.textView.delegate = self
//        addTextField()
        
        view.addSubview(self.textViewView)
        view.bringSubviewToFront(self.textViewView)
        textViewView.addSubview(textView)
        textViewView.addSubview(sendBtn)
        sendBtn.isEnabled = false
        createViewForTextView()
        setupTextViewConstraints()
        createSendButton()
//        setupCountLabel()
        addTableView()
//        view.bringSubviewToFront(countLabel)
        getUser {
            if let notificationParentId = self.notificationParentId, let notificationParentSubComment = self.notificationParentSubComment {
                self.getCommentByParentId(parent_id: notificationParentId, completion: {
                self.loadComments(completion: {
                    let indexPath = NSIndexPath(item: 0, section: 0)
                    let cell = self.myTableView.cellForRow(at: indexPath as IndexPath) as! CommentCell
                    cell.notificationParentId = notificationParentId
                    cell.addNotificationParentSubAndReply(subComment: self.notificationSubComments, parentSubComment: notificationParentSubComment)
                    //                    self.myTableView.reloadData()
                })
            })
            } else if let notificationParentId = self.notificationParentId {
            print("notification parent id")
                self.getCommentByParentId(parent_id: notificationParentId, completion: {
                self.loadComments(completion: {
                    let indexPath = NSIndexPath(item: 0, section: 0)
                    let cell = self.myTableView.cellForRow(at: indexPath as IndexPath) as! CommentCell
                    cell.notificationParentId = notificationParentId
                    cell.addNotificationSubComment(subComment: self.notificationSubComments)
//                    self.myTableView.reloadData()
                })
            })
            } else if self.notificationType == "commentedPost" || self.notificationType == "likedComment"  {
                self.getCommentByParentId(parent_id: self.post_comment_id, completion: {
                    let indexPath = NSIndexPath(row: 0, section: 0)
                    self.loadComments(completion: {
                        DispatchQueue.main.async {
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.myTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                        self.myTableView.delegate?.tableView!(self.myTableView, didSelectRowAt: indexPath)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            self.myTableView.deselectRow(at: indexPath, animated: true)
                            self.myTableView.delegate?.tableView!(self.myTableView, didDeselectRowAt: indexPath)
                            }
                        }
                    })
            })
        } else {
                self.loadComments(completion: {})
        }
        }
        
        
        view.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        if let tap = tap {
        view.addGestureRecognizer(tap)
        }
//
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let post_id = self.post_id {
            getAuthorByPostID(post_id: post_id)
        }
        
        self.view.layoutIfNeeded()
        
        
    }
    
    
    func getCommentByParentId(parent_id:String?, completion: @escaping(() -> ())) {
        guard let parent_id = parent_id else {
            return
        }
        print("parent_id get comment \(parent_id)")
        GETCommentById(id: parent_id).getComment { comments in
            self.comments = comments.map { comment in
                    let ret = CommentViewModel()
                    ret.mainComment = comment
            
                    print("this comment \(comment)")
                    return ret
                }
            print("self.comments get parent id \(self.comments[0])")
//            self.myTableView.reloadData()
            completion()
        }
            
    }
    
    func getAuthorByPostID(post_id: String) {
        GETByID(id: post_id, path: "getAuthorByPostID").getById {
            self.post_user_id = $0[0].author
        }
    }
    
    
    func getUser(completion: @escaping(()->())) {
        if let id = profile?.sub {
        print("profile?.sub id \(profile?.sub)")
        GetUsersById(id: id).getAllPosts {
            print("$0[0].username \($0[0].username)")
            if $0[0].username == nil {
                GETUser(id: id, path: "getUserInfo").getAllById {
                   self.username = $0[0].username
                   completion()
                }
            } else {
                self.username = $0[0].username
                completion()
            }
          }
        }
    }
    
   func setupCountLabel() {
        countLabel.textColor = UIColor.black
        countLabel.textAlignment = .center
        countLabel.layer.cornerRadius = 5
        countLabel.layer.borderWidth = 1.0
        countLabel.backgroundColor = UIColor.white
        countLabel.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        countLabel.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if CommentStruct.isSelected! && reply {
            textView.text = nil
            textView.textColor = UIColor.black
            reply = false
        }
        if CommentStruct.subCommentReplySelected! && subReply {
            textView.text = nil
            textView.textColor = UIColor.black
            subReply = false
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        countLabel.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 250
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = nil
            textView.textColor = UIColor.black
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            sendBtn.isEnabled = false
        } else {
            sendBtn.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter Comment"
            textView.textColor = UIColor.lightGray
        }
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Enter Comment"
//            textView.textColor = UIColor.lightGray
//        }
//    }
//

    
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
        if textView.text == "Reply" && self.textView.textColor == UIColor.lightGray {
            textView.text = "Enter Comment"
            textView.textColor = UIColor.lightGray
        }
        if textView.text == "" {
            textView.text = "Enter Comment"
            textView.textColor = UIColor.lightGray
        }
        print("dismissKeyBoard")
        comment.updateIsSelected(newBool: false)
        comment.updatesubReplyIsSelected(newBool: false)
    }
    
    @objc func handleKeyBoardNotification(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstraint?.constant = isKeyBoardShowing ? -keyboardFrame.height : 0

            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }
    }
    
    func loadComments(completion:@escaping(()->())) {
        guard let post_id = post_id else {
            return
        }
        let getComments = GETComments(id: post_id, path: "comments")
        getComments.getAllById { comments in
            if let notificationParentId = self.notificationParentId {
                let commentsFiltered = comments.filter {
                    return $0.id != notificationParentId
                }
                self.comments += commentsFiltered.map { comment in
                    let ret = CommentViewModel()
                    ret.mainComment = comment
                    
                    return ret
                }
                self.myTableView.reloadData()
                completion()
            }  else if let comment_id = self.post_comment_id {
                  let commentsFiltered = comments.filter {
                    return $0.id != comment_id
                }
                self.comments += commentsFiltered.map { comment in
                    let ret = CommentViewModel()
                    ret.mainComment = comment
                    
                    return ret
                }
                self.myTableView.reloadData()
                completion()
                
            } else {
              self.comments = comments.map { comment in
                let ret = CommentViewModel()
                ret.mainComment = comment
        
                return ret
            }
            self.myTableView.reloadData()
            completion()
            }
        }
        print("self.username \(self.username) this username \(self.username)")
    }
    

    
    func addTableView() {
        
        self.myTableView = UITableView()
        
        
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.myTableView.frame.size.height = self.view.frame.height
        //
        self.myTableView.frame.size.width = self.view.frame.width
        
        
        self.myTableView.register(CommentCell.self, forCellReuseIdentifier: "MyCell")
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.isScrollEnabled = true
        
//        myTableView.delaysContentTouches = false
        self.view.addSubview(self.myTableView)
        
    
        self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.myTableView.bottomAnchor.constraint(equalTo: self.textView.topAnchor).isActive = true
        
        self.myTableView.estimatedRowHeight = 80
        self.myTableView.rowHeight = UITableView.automaticDimension
        
        
        myTableView.layoutMargins = UIEdgeInsets.zero
        myTableView.separatorInset = UIEdgeInsets.zero
        
        
    }
    

    
    
    func setupTextViewConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        textView.topAnchor.constraint(equalTo: textViewView.topAnchor).isActive = true
        var frame = self.textView.frame
        frame.size.height = self.textView.contentSize.height
        self.textView.frame = frame
                
}
    
    func createViewForTextView() {
        textViewView.backgroundColor = UIColor.white
        textViewView.layer.borderColor = UIColor.lightGray.cgColor
        textViewView.layer.borderWidth = 1.0
        textViewView.translatesAutoresizingMaskIntoConstraints = false
        textViewView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textViewView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textViewView.heightAnchor.constraint(equalTo: textView.heightAnchor, constant: 50).isActive = true
        
        
        bottomConstraint = textViewView.bottomAnchor.constraint(equalTo: (self.view.safeAreaLayoutGuide.bottomAnchor), constant: 0)
        bottomConstraint?.isActive = true
    }
    
    func createSendButton() {
        let btnConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let btnSymbolImage = UIImage(systemName: "arrowshape.turn.up.right.fill", withConfiguration: btnConfiguration)
        sendBtn.setImage(btnSymbolImage, for: .normal)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendBtn.trailingAnchor.constraint(equalTo: textViewView.trailingAnchor, constant: -8).isActive = true
        sendBtn.bottomAnchor.constraint(equalTo: self.textViewView.bottomAnchor, constant: -15).isActive = true
        sendBtn.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        
    }
    
    @objc func sendComment() {
        if CommentStruct.isSelected == true {
          print("true isSelected")
          sendSubComment()
        } else if CommentStruct.subCommentReplySelected == true {
          sendSubCommentReply()
        } else {
          print("false not selected")
          performActionSend()
        }
        view.endEditing(true)
    }

    func sendSubComment() {
        print("sendSubComment")
        if let text = textView.text,
        let post_id = self.post_id,
        let username = self.username,
        let user_picture = profile?.picture,
        let user_id = profile?.sub,
            let index = self.index,
            let parent_id = parent_id, let comment_userID = self.comment_userID {
            print("comment_userID \(self.comment_userID)")
            let comment = Comment(post_id: post_id, username: username, user_picture: user_picture.absoluteString, user_id: user_id, text: text, parent_id: parent_id, comment_userID: comment_userID, tableview_index: index, parentsubcommentid: nil, post_user_id: nil)

            let postRequest = CommentPostRequest(endpoint: "sub_comment")
            postRequest.save(comment) { (result) in
                switch result {
                case .success(let comment):
                print("success saving comment")
                 self.replyingCommentCell?.addedSubComment()
             
                case .failure(let error):
                    print("An error occurred: \(error)")
                }
            }
        } else {
            
            print("text \(textView.text)")
            print("username \(self.username)")
            print("user_picture \(profile?.picture)")
            print("user_id \(profile?.sub)")
            print("parent_id \(parent_id)")
        }
        textView.text = ""
    }
    
    
    func sendSubCommentReply() {
        if let text = textView.text,
        let post_id = self.post_id,
        let username = self.username,
        let user_picture = profile?.picture,
        let user_id = profile?.sub,
        let parent_id = parent_id,
        let index = self.index,
        let subReplyUserId = self.subReplyUserId,
        let parentSubCommentId = self.parentSubCommentId,
        let usernameReply = usernameReply {
            print("sendSubCommentReply + \(parentSubCommentId)")
            let comment = Comment(post_id: post_id, username: username, user_picture: user_picture.absoluteString, user_id: user_id, text:
                "Reply To @\(usernameReply): \(text)", parent_id: parent_id, comment_userID: subReplyUserId, tableview_index: index, parentsubcommentid: parentSubCommentId, post_user_id: nil)
            
            let postRequest = CommentPostRequest(endpoint: "sub_comment")
            postRequest.save(comment) { (result) in
                switch result {
                case .success(let comment):
                  print("you have successfully saved a sub comment reply")
                  self.replyingCommentCell?.addedSubComment()
                case .failure(let error):
                    print("An error occurred: \(error)")
                }
            }
        } else {
            print("text \(textView.text)")
            print("username \(username)")
            print("user_picture \(profile?.picture)")
            print("user_id \(profile?.sub)")
            print("parent_id \(parent_id)")
            print("parentSubCommentId \(parentSubCommentId)")
        }
        textView.text = ""
    }
    
    func performActionSend() {
        if let text = textView.text,
        let post_id = self.post_id,
        let username = username,
        let user_picture = profile?.picture,
            let user_id = profile?.sub, let post_user_id = self.post_user_id {
            let comment = Comment(post_id: post_id, username: username, user_picture: user_picture.absoluteString, user_id: user_id, text: text, parent_id: nil, comment_userID: nil, tableview_index: nil, parentsubcommentid: nil, post_user_id: post_user_id)
            
            let postRequest = CommentPostRequest(endpoint: "comment")
            postRequest.save(comment) { (result) in
                switch result {
                case .success(let comment):
                    print("the following comment has been sent: \(comment)")
                    
                self.loadComments(completion: {
                    DispatchQueue.main.async {
                    let indexPath = NSIndexPath(row: 0, section: 0)
                    self.myTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
//                    self.myTableView.setContentOffset(.zero, animated: false)
//                    self.myTableView.beginUpdates()
//                    self.myTableView.endUpdates()
                    }
                })
                case .failure(let error):
                    print("An error occurred: \(error)")
                }
            }
        } else {
            print("text \(textView.text)")
            print("username \(username)")
            print("user_picture \(profile?.picture)")
            print("user_id \(profile?.sub)")
        }
        textView.text = ""
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("didDeselectRow")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! CommentCell
        cell.delegate = self
        cell.delegate2 = self
        cell.selectionStyle = .default
        cell.commentDelegate = self
        let item = comments[indexPath.item]
        cell.viewModel = item
        cell.index = indexPath
        cell.profile_username = self.username

        return cell
    }
    
    
}


extension CommentVC: CommentCellDelegate {
    
    func didTapProfile(user_id: String) {
        
    }
    
    func alertToDeleteSubComment(cell: CommentCell) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this comment?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            cell.deleteSubCommentAfterAlert()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
            self.present(alert, animated: true, completion: nil)
    }
    
    func alertToDeleteComment(cell: CommentCell) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this comment?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            cell.dltComment()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
            self.present(alert, animated: true, completion: nil)
    }
    
    func didTapDeleteComment(index: IndexPath) {
        comments.remove(at: index.row)
        myTableView.deleteRows(at: [index], with: UITableView.RowAnimation.automatic)
    }
    
    func didTapReplyBtn(parent_id: String, cell: CommentCell, user_id:String) {
        if !textView.isFirstResponder {
                   textView.becomeFirstResponder()
                   comment.updateIsSelected(newBool: true)
                   self.replyingCommentCell = cell
                   self.comment_userID = user_id
                   print("cell self this \(cell)")
                   self.index = cell.index?[1]
                   reply = true
                   self.parent_id = parent_id
        //           tap?.isEnabled = true

                    textView.text = nil
                   // If updated text view will be empty, add the placeholder
                   // and set the cursor to the beginning of the text view
                    if textView.text.isEmpty {

                       textView.text = "Reply"
                       textView.textColor = UIColor.lightGray

                       textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
                   }

                } else {
                    textView.text = nil
                    textView.resignFirstResponder()
                    if textView.text.isEmpty {

                        textView.text = "Enter Comment"
                        textView.textColor = UIColor.lightGray
         }
     }
    
  }
}


extension CommentVC: CommentCellDelegate2 {
    
    func didTapSubReplyBtn(username: String, parent_id:String, cell: CommentCell, parentSubCommentId: String, user_id:String) {
        if !textView.isFirstResponder {
                      textView.becomeFirstResponder()
                      comment.updateIsSelected(newBool: false)
                      comment.updatesubReplyIsSelected(newBool: true)
                      subReply = true
                      self.parent_id = parent_id
                      self.usernameReply = username
                      self.replyingCommentCell = cell
                      self.index = cell.index?[1]
                      self.parentSubCommentId = parentSubCommentId
                      self.subReplyUserId = user_id
//                      self.index = index
           //           tap?.isEnabled = true

                       textView.text = nil
                      // If updated text view will be empty, add the placeholder
                      // and set the cursor to the beginning of the text view
                       if textView.text.isEmpty {

                          textView.text = "Reply"
                          textView.textColor = UIColor.lightGray

                          textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
                      }

                   } else {
                       textView.text = nil
                       textView.resignFirstResponder()
                       if textView.text.isEmpty {

                           textView.text = "Enter Comment"
                           textView.textColor = UIColor.lightGray
            }
        }
        
    }
    
}


