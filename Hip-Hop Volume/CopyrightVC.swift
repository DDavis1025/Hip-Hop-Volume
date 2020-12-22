//
//  CopyrightVC.swift
//  Hip-Hop Volume
//
//  Created by Dillon Davis on 11/23/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class CopyrightVC: UIViewController, UIScrollViewDelegate {
    var profile = SessionManager.shared.profile
    var copyright_strikes:String = ""
    var data:[Copyright]?
    

    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.alwaysBounceVertical = true
        v.alwaysBounceHorizontal = false
        return v
    }()
    
    let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()


    
    lazy var label:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.sizeToFit()
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 1.5
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var copyrightLabel:UILabel = {
        let label = UILabel()
        label.text = "Has been removed for copyright infringement."
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 1.5
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var copyrightInfringement:UILabel = {
        let label = UILabel()
        label.text = "Copyright Infringement"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20)
//        label.minimumScaleFactor = 10/UIFont.labelFontSize
//        label.font = UIFont.systemFont(ofSize: 50)
        return label
    }()
    
    lazy var emailLabel:UILabel = {
        let label = UILabel()
        label.text = "Please check email for more information."
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 10/UIFont.labelFontSize
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var copyrightStrikes:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 10/UIFont.labelFontSize
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    init(data: [Copyright]) {
        self.data = data
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor.white
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollViewContstraints()
        contentViewContstraints()
        scrollViewDidScroll(scrollView)
        self.view.bringSubviewToFront(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(copyrightInfringement)
        contentView.addSubview(label)
        contentView.addSubview(copyrightLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(copyrightStrikes)
        copyrightInfringementConstraints()
        labelConstraints()
        copyrightLabelConstraints()
        emailLabelConstraints()
        copyrightStrikesConstraints()
        getCopyrightInfo()
        
        edgesForExtendedLayout = []
    }
    
    override func viewDidLayoutSubviews() {
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func scrollViewContstraints() {
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func contentViewContstraints() {
        contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func copyrightInfringementConstraints() {
        copyrightInfringement.translatesAutoresizingMaskIntoConstraints = false
        copyrightInfringement.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 5).isActive = true
        copyrightInfringement.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -10).isActive = true
           
       }
    
    func labelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: copyrightInfringement.bottomAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
           
       }
    
    func copyrightLabelConstraints() {
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        copyrightLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        copyrightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        copyrightLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -20).isActive = true
       }
    
    func emailLabelConstraints() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: copyrightLabel.bottomAnchor, constant: 20).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
           
       }
    
    func copyrightStrikesConstraints() {
        copyrightStrikes.translatesAutoresizingMaskIntoConstraints = false
        copyrightStrikes.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        copyrightStrikes.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20).isActive = true
        copyrightStrikes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        copyrightStrikes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
           
       }
    
    
//    func getCopyrightInfo() {
//        if let user_id = profile?.sub {
//        GETCopyrightInfo(user_id: user_id).get {
//            print("\($0) $0")
//            if $0.count > 0 {
//            var stringArray:[String] = $0.map { $0.message ?? "" }
//            stringArray.removeLast()
//            print("$0.count \($0.last?.count)")
//            self.label.attributedText = NSAttributedStringHelper.createBulletedList(fromStringArray: stringArray, font: UIFont.systemFont(ofSize: 20))
//
//            guard let last = $0.last else {
//             return
//            }
//            if let copyright_strikes = last.count {
//            if copyright_strikes >= 5 {
//                self.copyrightStrikes.text = "You have \(copyright_strikes) out of 5 copyright strikes. Which means your account will be removed for violating our terms of use"
//            } else {
//                self.copyrightStrikes.text = "You have \(copyright_strikes) out of 5 copyright strikes. If you have 5 strikes within the 90 day period of your first strike, your account will be removed."
//            }
//           }
//          }
//
//        }
//       }
//    }
    
    func getCopyrightInfo() {
           guard let data = self.data else {
             return
           }
            var stringArray:[String] = data.map { ($0.message ?? "") }
            stringArray.removeLast()
            self.label.attributedText = NSAttributedStringHelper.createBulletedList(fromStringArray: stringArray, font: UIFont.systemFont(ofSize: 20))
            
            guard let last = data.last else {
             return
            }
            if let copyright_strikes = last.count {
            if copyright_strikes >= 5 {
                self.copyrightStrikes.text = "You have \(copyright_strikes) out of 5 copyright strikes. Which means your account will be removed for violating our terms of use"
            } else {
                self.copyrightStrikes.text = "You have \(copyright_strikes) out of 5 copyright strikes. If you have 5 strikes within the 90 day period of your first strike, your account will be removed."
            }
           }

    }
    
    
    
    
    
    
}

class NSAttributedStringHelper {
    static func createBulletedList(fromStringArray strings: [String], font: UIFont? = nil) -> NSAttributedString {

        let fullAttributedString = NSMutableAttributedString()
        let attributesDictionary: [NSAttributedString.Key: Any]

        if font != nil {
            attributesDictionary = [NSAttributedString.Key.font: font!]
        } else {
            attributesDictionary = [NSAttributedString.Key: Any]()
        }

        for index in 0..<strings.count {
            let bulletPoint: String = "\u{2022}"
            var formattedString: String = "\(bulletPoint) \(strings[index])"

            if index < strings.count - 1 {
                formattedString = "\(formattedString)\n"
            }

            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            let paragraphStyle = NSAttributedStringHelper.createParagraphAttribute()
   attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
        fullAttributedString.append(attributedString)
       }

        return fullAttributedString
    }

    private static func createParagraphAttribute() -> NSParagraphStyle {
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 11
        return paragraphStyle
    }
}


