//
//  UserStore.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/1/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Cache
import Alamofire

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
    
    func create(username: String, callback: ((User?) -> Void)?) {
        var dictionary = Dictionary<String, Any>()
        dictionary["username"] = username
        dictionary["apn_token"] = UserDefaults.standard.string(forKey: "token")
        
        Alamofire.request("\(Backend.baseURL)/users", method: .post, parameters: dictionary, encoding: JSONEncoding.default,  headers: nil).responseJSON { (response) in
            let jsonDecoder = JSONDecoder()
            guard let data = response.data else {
                return
            }
            do {
                let user = try jsonDecoder.decode(User.self, from: data)
                callback?(user)
                try? self.storage.setObject(user, forKey: "user")
            } catch let error {
                callback?(nil)
                print(error)
                print(response.value)
            }
        }
    }
    
    func connect(toFacebook connection: String, callback: ((User) -> Void)?) {
        
    }
    
    func search(query: String, callback: (([User]?) -> Void)?) {
        Alamofire.request("\(Backend.baseURL)/search?query=\(query)", method: .get, parameters: nil, encoding: JSONEncoding.default,  headers: nil).responseJSON { (response) in
            let jsonDecoder = JSONDecoder()
            guard let data = response.data else {
                return
            }
            do {
                let users = try jsonDecoder.decode([User].self, from: data)
                callback?(users)
            } catch let error {
                callback?(nil)
                print(error)
                print(response.value)
            }
        }
    }
}
