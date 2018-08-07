//
//  AddAlarmViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/6/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class AddAlarmViewController: UIViewController {

    var nameLabel = TitleLabel()
    var nameField = UITextField()
    
    var alarmLabel = TitleLabel()
    var alarmDescriptionLabel = SmallTextLabel()
    
    var recordButton = UIButton()
    var musicButton = UIButton()
    
    var repeatLabel = TitleLabel()
    var repeatStepper = UIStepper()
    var repeatNumberLabel = UILabel()
    var repeatTimesLabel = UILabel()
    
    var previewLabel = TitleLabel()
    
    var createButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = "Name"
        self.nameField.placeholder = "ex. Morning Mayhem"
        
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.nameField)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.nameLabel.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 10
        self.nameLabel.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor + 20
        
        self.nameField.topAnchor == self.nameLabel.bottomAnchor + 10
        self.nameField.leadingAnchor == self.view.leadingAnchor + 20
    }
}
