//
//  Alarm.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class Alarm: Codable {
    var id: Int
    var name: String
    var duration: Double
    var username: String
    var fileURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case duration = "duration"
        case username = "username"
        case fileURL = "file_url"
    }
}
