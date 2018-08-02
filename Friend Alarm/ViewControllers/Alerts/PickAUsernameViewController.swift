//
//  PickAUsernameViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/1/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class PickAUsernameViewController: UIViewController {
    
    var titleLabel = TitleLabel()
    var infoLabel = SmallTextLabel()
    var usernameTextField = UITextField()
    var submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(named: "header-color")
        
        self.titleLabel.font = UIFont.init(name: self.titleLabel.font.fontName, size: 19.0)
        self.titleLabel.text = "Pick a Username"
        
        self.infoLabel.text = "Select a username so that your friends can find you!"
        self.infoLabel.textAlignment = .center
        
        self.usernameTextField.borderStyle = .none
        self.usernameTextField.backgroundColor = UIColor(named: "cell-color")
        self.usernameTextField.placeholder = "Username"
        self.usernameTextField.textAlignment = .center
        self.usernameTextField.textColor = UIColor(named: "tint-color")
        self.usernameTextField.tintColor = UIColor(named: "tint-color")
        self.usernameTextField.font = UIFont.init(name: "HelveticaNeue-Medium", size: 11.0)
        self.usernameTextField.layer.cornerRadius = 5
        
        self.submitButton.backgroundColor = UIColor(named: "button-color")
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.setTitleColor(UIColor(named: "button-text-color"), for: .normal)
        self.submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 11.0)
        self.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        self.submitButton.layer.cornerRadius = 5
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.usernameTextField)
        self.view.addSubview(self.submitButton)
        
        self.setupConstraints()
    }
    
    @objc func submit() {
        
    }
    
    func setupConstraints() {
        self.titleLabel.topAnchor == self.view.topAnchor + 20
        self.titleLabel.centerXAnchor == self.view.centerXAnchor
        
        self.infoLabel.topAnchor == self.titleLabel.bottomAnchor + 10
        self.infoLabel.leadingAnchor == self.view.leadingAnchor + 20
        self.infoLabel.trailingAnchor == self.view.trailingAnchor - 20
        
        self.usernameTextField.topAnchor == self.infoLabel.bottomAnchor + 15
        self.usernameTextField.leadingAnchor == self.view.leadingAnchor + 40
        self.usernameTextField.trailingAnchor == self.view.trailingAnchor - 40
        self.usernameTextField.heightAnchor == 23
        
        self.submitButton.topAnchor == self.usernameTextField.bottomAnchor + 10
        self.submitButton.widthAnchor == 115
        self.submitButton.centerXAnchor == self.view.centerXAnchor
        self.submitButton.bottomAnchor == self.view.bottomAnchor - 20
        
    }
}
