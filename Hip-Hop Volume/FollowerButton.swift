//
//  FollowerButton.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/1/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

enum ButtonState {
    case add
    case delete
}

class FollowerButton: UIButton {
    var notification:Bool?
    var buttonState:ButtonState? {
        didSet {
            updateButtonView(for: buttonState!)
        }
    }

    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonState = .add
        updateButtonView(for: buttonState!)
    }
    
    
    
    private func updateButtonView(for state: ButtonState) {
    switch buttonState {
    case .add:
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "person.badge.plus", withConfiguration: config) as UIImage?
        let blackImage = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        self.setImage(blackImage, for: .normal)
        self.setTitle("Follow", for: .normal)
        self.setTitleColor(.black, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)

    case .delete:
         let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .black, scale: .medium)
         let image = UIImage(systemName: "person.badge.minus.fill", withConfiguration: config) as UIImage?
         let blackImage = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
         self.setImage(blackImage, for: .normal)
         self.setTitle("Following", for: .normal)
         self.setTitleColor(.black, for: .normal)
         titleLabel?.font = .systemFont(ofSize: 14)
        
         default: break
        }
    }


  }

