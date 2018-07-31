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
    var untilItsTimeToWakeUpLabel = UILabel()
    
    var alarmTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
