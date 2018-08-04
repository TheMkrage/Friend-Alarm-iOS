//
//  AddFriendCell.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/3/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class AddFriendCell: UITableViewCell {
    
    var usernameLabel = TitleLabel()
    var addFriendButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        self.addFriendButton.setTitle("+", for: .normal)
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.usernameLabel.centerYAnchor == self.centerYAnchor
        self.usernameLabel.leadingAnchor == self.leadingAnchor + 16
        
        self.addFriendButton.centerYAnchor == self.centerYAnchor
        self.addFriendButton.trailingAnchor == self.trailingAnchor - 20
    }
}
