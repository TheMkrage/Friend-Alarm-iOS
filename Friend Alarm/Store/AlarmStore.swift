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
                    print(response.value)
                    if let err = response.error{
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
}
