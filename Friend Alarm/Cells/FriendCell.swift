//
//  FriendCell.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class FriendCell: UITableViewCell {
    
    var usernameLabel = TitleLabel()
    var alarmIcon = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        
        self.alarmIcon.image = #imageLiteral(resourceName: "alarm-icon")
        self.alarmIcon.isHidden = true
        
        self.selectionStyle = .none
        
        self.addSubview(self.usernameLabel)
        self.addSubview(self.alarmIcon)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.usernameLabel.centerYAnchor == self.centerYAnchor
        self.usernameLabel.leadingAnchor == self.leadingAnchor + 16
        
        self.alarmIcon.centerYAnchor == self.centerYAnchor
        self.alarmIcon.trailingAnchor == self.trailingAnchor - 20
    }
}
