//
//  User.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class User: Codable {
    var username: String
    var facebookConnection: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case facebookConnection = "facebook_connnection"
    }
}
