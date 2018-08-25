//
//  Alarm.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class Alarm: Codable, Equatable {
    var id: Int
    var name: String
    var duration: Double
    var username: String
    var fileURL: String
    
    var isRecommended: Bool {
        get {
            return self.username != UserStore.shared.get()?.username
        }
    }
    var isHighPriority: Bool = false
    var isSecret: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case duration = "duration"
        case username = "username"
        case fileURL = "file_url"
        case isHighPriority = "is_high_priority"
        case isSecret = "is_secret"
    }
    
    static func ==(lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.id == rhs.id
    }
}
