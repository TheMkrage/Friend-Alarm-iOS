//
//  UserStore.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/1/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Cache

class UserStore: NSObject {
    static var shared = UserStore()
    var diskConfig = DiskConfig.init(name: "user", expiry: .never, maxSize: 2000, directory: nil, protectionType: nil)
    lazy var storage = try! Storage(diskConfig: diskConfig)
    private override init() {   }
    
    func hasRegisteredUsername() -> Bool {
        guard (try? storage.object(ofType: User.self, forKey: "user")) != nil else {
            return false
        }
        return true
    }
    
    func get() -> User? {
        return try? storage.object(ofType: User.self, forKey: "user")
    }
    
    func create(username: String, callback: ((User) -> Void)?) {
        
    }
    
    func connect(toFacebook connection: String, callback: ((User) -> Void)?) {
        
    }
}
