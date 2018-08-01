//
//  MyAlarmViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class MyAlarmViewController: UIViewController {

    var alarmSwitch = UISwitch()
    var timeUntilAlarmLabel = UILabel()
    var untilItsTimeToWakeUpLabel = SmallTextLabel()
    
    var alarmTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
        
        self.title = "My Alarm"
        
        self.timeUntilAlarmLabel.font = UIFont(name: "DS-Digital", size: 64)
        self.timeUntilAlarmLabel.textColor = UIColor(named: "alarm-red")
        self.timeUntilAlarmLabel.text = "alarm off"
        
        self.untilItsTimeToWakeUpLabel.text = "until it's time to wake up"
        self.untilItsTimeToWakeUpLabel.textColor = UIColor(named: "alarm-red")
        
        self.view.addSubview(self.alarmSwitch)
        self.view.addSubview(self.timeUntilAlarmLabel)
        self.view.addSubview(self.untilItsTimeToWakeUpLabel)
        self.view.addSubview(self.alarmTable)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.alarmSwitch.centerXAnchor == self.view.centerXAnchor
        self.alarmSwitch.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 20
        
        self.timeUntilAlarmLabel.topAnchor == self.alarmSwitch.bottomAnchor + 20
        self.timeUntilAlarmLabel.centerXAnchor == self.view.centerXAnchor
        
        self.untilItsTimeToWakeUpLabel.centerXAnchor == self.view.centerXAnchor
        self.untilItsTimeToWakeUpLabel.topAnchor == self.timeUntilAlarmLabel.bottomAnchor
        
        self.alarmTable.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor
        self.alarmTable.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor
        self.alarmTable.trailingAnchor == self.view.safeAreaLayoutGuide.trailingAnchor
        self.alarmTable.topAnchor ==  self.untilItsTimeToWakeUpLabel.bottomAnchor + 20
    }
}
