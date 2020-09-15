//
//  UserInfoCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/19/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class PersonInformationTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    override func prepareForReuse() {
            super.prepareForReuse()
             valueLabel.text = ""

        }
  
    func setUpView(title: String, value: String) {
//    let titleLabel = UILabel()
    titleLabel.text = title
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    
    valueLabel.text = value
    
    let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 5
    
    contentView.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
    stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
    stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
    stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
}
