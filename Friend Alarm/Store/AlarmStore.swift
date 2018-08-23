//
//  AlarmStore.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/11/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Cache
import Alamofire

class AlarmStore: NSObject {
    static var shared = AlarmStore()
    var diskConfig = DiskConfig.init(name: "alarms", expiry: .never, maxSize: 2000, directory: nil, protectionType: nil)
    lazy var storage = try! Storage(diskConfig: diskConfig)
    private override init() {   }
    
    func create(audioData: Data?, name: String, duration: Int){
        var parameters = Dictionary<String, Any>()
        parameters["name"] = name
        parameters["duration"] = duration
        parameters["user_id"] = UserStore.shared.get()?.id ?? -1
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = audioData{
                multipartFormData.append(data, withName: "audio_file", fileName: "audio_file.m4a", mimeType: "audio/m4a")
            }
            
        }, usingThreshold: UInt64.init(), to: "\(Backend.baseURL)/alarms", method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    let jsonDecoder = JSONDecoder()
                    guard let data = response.data else {
                        return
                    }
                    do {
                        let alarm = try jsonDecoder.decode(Alarm.self, from: data)
                        var alarms = try? self.storage.object(ofType: [Alarm].self, forKey: "alarms") ?? []
                        alarms?.append(alarm)
                        try? self.storage.setObject(alarms, forKey: "alarms")
                    } catch let error {
                        print(error)
                        print(response.value)
                    }
                    
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
    
    func get(callback: (([Alarm]) -> Void)?) {
        let alarms = (try? self.storage.object(ofType: [Alarm].self, forKey: "alarms")) ?? []
        callback?(alarms)
        
        guard let id = UserStore.shared.get()?.id else {
            return
        }
        Alamofire.request("\(Backend.baseURL)/users/\(id)/alarms", method: .get, parameters: nil, encoding: JSONEncoding.default,  headers: nil).responseJSON { (response) in
            let jsonDecoder = JSONDecoder()
            guard let data = response.data else {
                return
            }
            do {
                let alarms = try jsonDecoder.decode([Alarm].self, from: data)
                callback?(alarms)
                try? self.storage.setObject(alarms, forKey: "alarms")
            } catch let error {
                callback?([])
                print(error)
                print(response.value)
            }
        }
    }
    
    func getLastAlarm() -> Date? {
        return try? self.storage.object(ofType: Date.self, forKey: "lastAlarm")
    }
    
    private func setLastAlarm(time: Date) {
        try? self.storage.setObject(time, forKey: "lastAlarm")
    }
    
    func isAlarmSet() -> Bool {
        return (try? self.storage.object(ofType: Bool.self, forKey: "isAlarmSet")) ?? false
    }
    
    private func set(isAlarmSet: Bool) {
        try? self.storage.setObject(isAlarmSet, forKey: "isAlarmSet")
    }
    
    func turnAlarmOn(time: Date, alarm: Alarm?) {
        guard let id = UserStore.shared.get()?.id, time != self.getLastAlarm() else {
            return
        }
        var parameters = Dictionary<String, Any>()
        parameters["alarm_id"] = alarm?.id ?? -1
        parameters["time"] = DateFormatter.iso8601.string(from: time)
        print(parameters["time"])
        self.setLastAlarm(time: time)
        self.set(isAlarmSet: true)
        Alamofire.request("\(Backend.baseURL)/users/\(id)/schedule" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
        }
    }
    
    func turnAlarmOff() {
        guard let id = UserStore.shared.get()?.id else {
            return
        }
        self.set(isAlarmSet: false)
        Alamofire.request("\(Backend.baseURL)/users/\(id)/schedule" , method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response.value)
        }
    }
}
