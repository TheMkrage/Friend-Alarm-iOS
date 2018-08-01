//
//  AlarmTableViewCell.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class AlarmTableViewCell: UITableViewCell {
    
    var nameLabel = TitleLabel()
    var userLabel = SubtitleLabel()
    
    var playButton = UIButton()
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
        self.isUserInteractionEnabled = true
        self.playButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        self.alarmIcon.image = #imageLiteral(resourceName: "alarm-icon")
        self.alarmIcon.isHidden = true
        
        self.selectionStyle = .none
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.userLabel)
        self.addSubview(self.playButton)
        self.addSubview(self.alarmIcon)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.nameLabel.topAnchor == self.topAnchor + 11
        self.nameLabel.leadingAnchor == self.leadingAnchor + 16
        self.nameLabel.trailingAnchor == self.trailingAnchor - 16
        
        self.userLabel.topAnchor == self.nameLabel.bottomAnchor
        self.userLabel.leadingAnchor == self.nameLabel.leadingAnchor
        
        self.playButton.trailingAnchor == self.trailingAnchor - 55
        self.playButton.centerYAnchor == self.centerYAnchor
        
        self.alarmIcon.trailingAnchor == self.trailingAnchor - 20
        self.alarmIcon.centerYAnchor == self.centerYAnchor
    }
}
