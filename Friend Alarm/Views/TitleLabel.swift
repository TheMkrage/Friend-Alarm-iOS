//
//  TitleLabel.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/30/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.font = UIFont(name: "STHeiti", size: 17)
    }
}
