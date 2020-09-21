//
//  SubCommentsCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/21/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import UIKit

protocol SubCommentViewDelegate: class {
    func subCommentLikePressed(sender: UIButton)
    func replyToSubComment(sender: UIButton)
    func deleteSubComment(sender:UIButton)
    
}

class SubCommentView: UIView {
    
    weak var delegate: SubCommentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(user_image)
        addSubview(username)
        addSubview(textView)
        addSubview(likeBtn)
        addSubview(numberOfLikes)
        addSubview(replyBtn)
        addSubview(dltSubCommentBtn)
        replyBtnConstraints()
        setImageConstraints()
        setUsernameConstraints()
        textViewContstraints()
        commentLikeBtnConstraints()
        commentLikesConstraints()
        dltBtnConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var replyBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Reply", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(replyToSubComment(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var dltSubCommentBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.sizeToFit()
//        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(dltSubComment(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var likeBtn:UIButton = {
        let btn = UIButton()
        let symbol = UIImage(systemName: "heart")
        btn.setImage(symbol , for: .normal)
        btn.tintColor = UIColor.darkGray
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(subCommentLikePressed(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var numberOfLikes:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    
    
    lazy var textView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.sizeToFit()
        tv.backgroundColor = UIColor.lightGray
        tv.textContainer.maximumNumberOfLines = 0
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.font = UIFont(name: "GillSans", size: 18)
        return tv
    }()
    
    lazy var user_image: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    lazy var username:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    @objc func subCommentLikePressed(sender:UIButton) {
        print("delegate \(delegate)")
        if let delegate = delegate {
            delegate.subCommentLikePressed(sender: sender)
        }
    }
    
    @objc func dltSubComment(sender:UIButton) {
        if let delegate = delegate {
            delegate.deleteSubComment(sender: sender)
        }
    }
    
    @objc func replyToSubComment(sender:UIButton) {
        print("delegate \(delegate)")
        if let delegate = delegate {
            delegate.replyToSubComment(sender: sender)
        }
    }
    
    func replyBtnConstraints() {
        replyBtn.translatesAutoresizingMaskIntoConstraints = false
        replyBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        replyBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        replyBtn.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        replyBtn.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 1).isActive = true
        replyBtn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func dltBtnConstraints() {
        dltSubCommentBtn.translatesAutoresizingMaskIntoConstraints = false
//        dltSubCommentBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        dltSubCommentBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dltSubCommentBtn.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8).isActive = true
//        dltSubCommentBtn.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 1).isActive = true
        dltSubCommentBtn.centerYAnchor.constraint(equalTo: replyBtn.centerYAnchor).isActive = true
        
    }
    
    func commentLikesConstraints() {
        numberOfLikes.translatesAutoresizingMaskIntoConstraints = false
        numberOfLikes.widthAnchor.constraint(equalToConstant: 60).isActive = true
        numberOfLikes.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfLikes.centerXAnchor.constraint(equalTo: likeBtn.centerXAnchor).isActive = true
        numberOfLikes.topAnchor.constraint(equalTo: likeBtn.bottomAnchor, constant: -5).isActive = true
    }
    
    func commentLikeBtnConstraints() {
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likeBtn.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        likeBtn.topAnchor.constraint(equalTo: textView.topAnchor, constant: -5).isActive = true
    }
    
    func setImageConstraints() {
        user_image.translatesAutoresizingMaskIntoConstraints = false
        user_image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        user_image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        user_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        user_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setUsernameConstraints() {
        username.translatesAutoresizingMaskIntoConstraints = false
        username.topAnchor.constraint(equalTo: user_image.topAnchor, constant: 5).isActive = true
        username.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 8).isActive = true
        username.heightAnchor.constraint(equalToConstant: 10).isActive = true
        username.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func textViewContstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 5).isActive = true
        textView.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 8).isActive = true
        textView.trailingAnchor.constraint(equalTo: likeBtn.leadingAnchor, constant: -3).isActive = true
//        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
//        textView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//                var frame = self.textView.frame
//                frame.size.height = self.textView.contentSize.height
//                self.textView.frame = frame
//        //        textViewDidChange(textView: self.textView)
        
    }
    
    
}
