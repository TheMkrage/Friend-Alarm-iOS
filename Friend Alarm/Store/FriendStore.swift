//
//  FriendStore.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/3/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Cache
import Alamofire

class FriendStore: NSObject {
    static var shared = FriendStore()
    var diskConfig = DiskConfig.init(name: "friends", expiry: .never, maxSize: 2000, directory: nil, protectionType: nil)
    lazy var storage = try! Storage(diskConfig: diskConfig)
    private override init() {   }
    
    func isFriend(user: User) -> Bool {
        let friends = self.getFriends()
        return friends.contains(user)
    }
    
    func getFriends() -> [User] {
        let savedFriends = try? self.storage.object(ofType: [User].self, forKey: "friends")
        return savedFriends ?? []
    }
    
    func toggleFriend(user: User) {
        var friends = self.getFriends()
        if self.isFriend(user: user) {
            let removedFriends = friends.filter {$0 != user}
            try? self.storage.setObject(removedFriends, forKey: "friends")
        } else {
            friends.append(user)
            try? self.storage.setObject(friends, forKey: "friends")
        }
    }
    
    func addAlarm(friendId: Int, isSecret: Bool, isHighPriority: Bool, alarmId: Int, callback: @escaping (Bool) -> ()) {
        guard let userId = UserStore.shared.get()?.id else {
            return
        }
        var dictionary = Dictionary<String, Any>()
        dictionary["referrer_id"] = userId
        dictionary["owner_id"] = friendId
        dictionary["is_secret"] = isSecret
        dictionary["is_high_priority"] = isHighPriority
        dictionary["alarm_id"] = alarmId
        
        Alamofire.request("\(Backend.baseURL)/user_alarms", method: .post, parameters: dictionary, encoding: JSONEncoding.default,  headers: nil).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {
                callback(false)
                return
            }
            callback(statusCode == 201)
        }
    }
}
