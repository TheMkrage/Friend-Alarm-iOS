//
//  DatePickerLabel.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/16/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class DatePickerLabel: UILabel {
    
    private let _inputView: UIView? = {
        let picker = UIDatePicker()
        picker.backgroundColor = UIColor.init(named: "background-color")
        picker.datePickerMode = .time
        picker.setValue(UIColor.init(named: "tint-color"), forKey: "textColor")
        return picker
    }()
    
    private let _inputAccessoryToolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barTintColor = UIColor.init(named: "header-color")
        toolBar.tintColor = UIColor.init(named: "header-text-color")
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        toolBar.sizeToFit()
        
        return toolBar
    }()
    
    override var inputView: UIView? {
        return _inputView
    }
    
    override var inputAccessoryView: UIView? {
        return _inputAccessoryToolbar
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        _inputAccessoryToolbar.setItems([ spaceButton, doneButton], animated: false)
        
        self.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchPicker))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    @objc private func launchPicker() {
        becomeFirstResponder()
    }
    
    @objc private func doneClick() {
        resignFirstResponder()
    }
}
