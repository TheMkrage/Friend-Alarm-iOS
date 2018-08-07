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
    
    var repeatNumberLabel = TitleLabel()
    var repeatTimesLabel = TitleLabel()
    lazy var repeatStackView = UIStackView(arrangedSubviews: [repeatNumberLabel, repeatTimesLabel])
    
    var previewLabel = TitleLabel()
    var previewPlayButton = UIButton()
    
    var createButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(named: "background-color")

        self.nameLabel.text = "Name"
        self.nameField.attributedPlaceholder = NSAttributedString(string:"ex. Morning Mayhem", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(named: "tint-color") as Any])
        self.nameField.layer.cornerRadius = 5
        
        self.alarmLabel.text = "Alarm"
        self.alarmDescriptionLabel.text = "Make sure it could wake somebody up!"
        
        self.recordButton.backgroundColor = UIColor.white
        self.musicButton.backgroundColor = UIColor.white
        
        self.repeatLabel.text = "Repeat"
        self.repeatTimesLabel.font = UIFont(name: self.repeatTimesLabel.font.fontName, size: 11.0)
        self.repeatTimesLabel.text = "Times"
        self.repeatNumberLabel.text = "\(1)"
        self.repeatNumberLabel.font = UIFont(name: self.repeatNumberLabel.font.fontName, size: 24.0)
        self.repeatStackView.spacing = 6
        self.repeatStepper.tintColor = UIColor.init(named: "dark-mode-orange")
        
        self.previewLabel.text = "Preview"
        self.previewPlayButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        
        self.createButton.backgroundColor = UIColor(named: "button-color")
        self.createButton.setTitle("Create", for: .normal)
        self.createButton.setTitleColor(UIColor(named: "button-text-color"), for: .normal)
        self.createButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        self.createButton.layer.cornerRadius = 17.5
        
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.nameField)
        self.view.addSubview(self.alarmLabel)
        self.view.addSubview(self.alarmDescriptionLabel)
        self.view.addSubview(self.recordButton)
        self.view.addSubview(self.musicButton)
        self.view.addSubview(self.repeatLabel)
        self.view.addSubview(self.repeatStepper)
        self.view.addSubview(self.self.repeatStackView)
        self.view.addSubview(self.previewLabel)
        self.view.addSubview(self.previewPlayButton)
        self.view.addSubview(self.createButton)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.nameLabel.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 10
        self.nameLabel.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor + 20
        
        self.nameField.topAnchor == self.nameLabel.bottomAnchor + 10
        self.nameField.leadingAnchor == self.view.leadingAnchor + 20
        self.nameField.trailingAnchor == self.view.trailingAnchor - 20
        self.nameField.heightAnchor == 26
        
        self.alarmLabel.topAnchor == self.nameField.bottomAnchor + 20
        self.alarmLabel.leadingAnchor == self.view.leadingAnchor + 20
        
        self.alarmDescriptionLabel.topAnchor == self.alarmLabel.bottomAnchor
        self.alarmDescriptionLabel.leadingAnchor == self.view.leadingAnchor + 20
        
        self.musicButton.leadingAnchor == self.view.leadingAnchor + 20
        self.musicButton.topAnchor == self.alarmDescriptionLabel.bottomAnchor + 16
        self.musicButton.widthAnchor == self.musicButton.heightAnchor
        self.musicButton.trailingAnchor == self.recordButton.leadingAnchor - 40
        
        self.recordButton.topAnchor == self.alarmDescriptionLabel.bottomAnchor + 16
        self.recordButton.trailingAnchor == self.view.trailingAnchor - 20
        self.recordButton.widthAnchor == self.recordButton.heightAnchor
        self.recordButton.widthAnchor == self.musicButton.widthAnchor
        
        self.repeatLabel.centerXAnchor == self.musicButton.centerXAnchor
        self.repeatLabel.topAnchor == self.musicButton.bottomAnchor + 28
        
        self.repeatStepper.topAnchor == self.repeatLabel.bottomAnchor + 15
        self.repeatStepper.centerXAnchor == self.repeatLabel.centerXAnchor
        
        self.repeatStackView.topAnchor == self.repeatStepper.bottomAnchor + 11
        self.repeatStackView.centerXAnchor == self.repeatStepper.centerXAnchor
        
        self.previewLabel.topAnchor == self.recordButton.bottomAnchor + 28
        self.previewLabel.centerXAnchor == self.recordButton.centerXAnchor
        
        self.previewPlayButton.centerYAnchor == self.repeatStepper.centerYAnchor
        self.previewPlayButton.centerXAnchor == self.previewLabel.centerXAnchor
        
        self.createButton.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor - 40
        self.createButton.centerXAnchor == self.view.centerXAnchor
        self.createButton.widthAnchor == 190
        self.createButton.heightAnchor == 35
    }
}
