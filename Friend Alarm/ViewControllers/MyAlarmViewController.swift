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
    
    var alarms = [Alarm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Alarm"
        
        self.timeUntilAlarmLabel.font = UIFont(name: "DS-Digital", size: 64)
        self.timeUntilAlarmLabel.textColor = UIColor(named: "alarm-red")
        self.timeUntilAlarmLabel.text = "alarm off"
        
        self.untilItsTimeToWakeUpLabel.text = "until it's time to wake up"
        self.untilItsTimeToWakeUpLabel.textColor = UIColor(named: "alarm-red")
        
        self.alarmTable.delegate = self
        self.alarmTable.dataSource = self
        self.alarmTable.separatorStyle = .none
        self.alarmTable.rowHeight = 70
        
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
        self.alarmTable.topAnchor ==  self.untilItsTimeToWakeUpLabel.bottomAnchor + 40
    }
}

extension MyAlarmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarms.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Alarms"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarm = self.alarms[indexPath.row]
        
        let cell = AlarmTableViewCell(style: .default, reuseIdentifier: "Alarm")
        cell.nameLabel.text = "name"
        cell.userLabel.text = "user"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "header-color")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: "header-text-color")
    }
}
