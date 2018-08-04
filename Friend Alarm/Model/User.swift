//
//  User.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class User: Codable, Hashable {
    lazy var hashValue = self.id
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var username: String
    var facebookConnection: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case facebookConnection = "facebook_connnection"
    }
}
