//
//  DatePickerLabel.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/16/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegate {
    @objc optional func timeChanged(time: Date)
    @objc optional func donePressed(time: Date)
}

class DatePickerLabel: UILabel {
    
    var delegate: DatePickerDelegate?
    
    private let _inputView: UIView? = {
        let picker = UIDatePicker()
        picker.backgroundColor = UIColor.init(named: "background-color")
        picker.datePickerMode = .time
        picker.setValue(UIColor.init(named: "tint-color"), forKey: "textColor")
        picker.addTarget(self, action: #selector(timeChanged(sender:)), for: .valueChanged)
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
    
    convenience init(initialTime: Date?) {
        self.init(frame: CGRect.zero)
        guard let datePicker = self.inputView as? UIDatePicker,
        let initialTime = initialTime else{
            return
        }
        
        // translate the saved date into today's time
        let calendar = Calendar.current
        var scheduleComponents = calendar.dateComponents([.hour, .minute], from: initialTime)
        
        let today = Date()
        let todayDayComponent = calendar.component(.day, from: today)
        let todayMonthComponent = calendar.component(.month, from: today)
        let todayYearComponent = calendar.component(.year, from: today)
        scheduleComponents.setValue(todayDayComponent, for: .day)
        scheduleComponents.setValue(todayMonthComponent, for: .month)
        scheduleComponents.setValue(todayYearComponent, for: .year)
        
        guard let initialAdjustedDate = calendar.date(from: scheduleComponents) else {
            return
        }
        //datePicker.minimumDate = initialAdjustedDate
        datePicker.date = initialAdjustedDate
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
    
    @objc private func timeChanged(sender: UIDatePicker) {
        self.text = sender.date.formatted
        self.delegate?.timeChanged?(time: sender.date)
    }
    
    @objc private func doneClick() {
        resignFirstResponder()
        guard let datePicker = self.inputView as? UIDatePicker else {
            fatalError()
        }
        self.delegate?.donePressed?(time: datePicker.date)
    }
}
