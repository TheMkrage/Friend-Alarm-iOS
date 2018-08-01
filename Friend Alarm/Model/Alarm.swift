//
//  Alarm.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class Alarm: Codable {
    var name: String
    var duration: Double
    var userId: Int
    var fileURL: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case duration = "duration"
        case userId = "user_id"
        case fileURL = "file_url"
    }
}
