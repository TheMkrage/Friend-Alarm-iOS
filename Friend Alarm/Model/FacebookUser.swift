//
//  FacebookUser.swift
//  
//
//  Created by Matthew Krager on 7/31/18.
//

import UIKit

class FacebookUser: Codable {
    var name: String
    var profilePicURL: String
    var facebookConnection: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case facebookConnection = "facebook_connnection"
        case profilePicURL = "profile_pic_url"
    }
}
