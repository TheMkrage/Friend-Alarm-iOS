//
//  AlarmScheduler.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/3/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class AlarmScheduler: NSObject {
    func scheduleAlarm(time: Date) {
        AlarmStore.shared.setLastAlarm(time: time)
    }
}
