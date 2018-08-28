//
//  AlarmPlayer.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/19/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import Alamofire

class AlarmPlayer: NSObject {
    static var shared = AlarmPlayer()
    private override init() {   }
    
    private var player: AVAudioPlayer? = AVAudioPlayer()
    var alamofire = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "background"))
    
    
    func stop() {
        print("stop")
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func playAlarm(id: Int, remoteUrl: String?) {
        
        let urlToAudioFile = self.getDocumentsDirectory().appendingPathComponent("\(id).m4a")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.duckOthers, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        
            if FileManager.default.fileExists(atPath: urlToAudioFile.path) {
                self.player = try AVAudioPlayer(contentsOf: urlToAudioFile, fileTypeHint: AVFileType.m4a.rawValue)
                
                guard let player = self.player else {
                    return
                }
                player.numberOfLoops = 10
                let volumeView = MPVolumeView()
                volumeView.volumeSlider.value = 1.0
                
                player.play()
                UserDefaults.standard.setValue(false, forKey: "needsToAlarm")
            } else {
                guard let remoteURLString = remoteUrl, let url = URL.init(string: remoteURLString) else {
                    self.playDefaultAlarm()
                    return
                }
                self.downloadAndPlay(url: url, urlToAudioFile: urlToAudioFile)
            }
            
        } catch {
            NSLog("Audio Session error: \(error)")
            if UserDefaults.standard.bool(forKey: "needsToAlarm") {
                self.playDefaultAlarm()
            } else {
                guard let remoteURLString = remoteUrl, let url = URL.init(string: remoteURLString) else {
                    self.playDefaultAlarm()
                    return
                }
                self.downloadAndPlay(url: url, urlToAudioFile: urlToAudioFile)
            }
        }
    }
    
    private func downloadAndPlay(url: URL, urlToAudioFile: URL) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (urlToAudioFile, [.removePreviousFile])
        }
        let taskID = self.beginBackgroundTask()
        Alamofire.download(url, to: destination).responseData(completionHandler: { (response) in
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(true, forKey: "needsToAlarm")
            }
        })
    }
    
    func beginBackgroundTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: {})
    }
    
    func endBackgroundTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskID)
    }
    
    private func playDefaultAlarm() {
        print("play default")
        do {
            
            guard let url = Bundle.main.url(forResource: "Untitled", withExtension:"m4a") else {
                fatalError()
            }
            self.player = try AVAudioPlayer.init(contentsOf: url, fileTypeHint: "m4a")
            
            guard let player = self.player else {
                return
            }
            player.numberOfLoops = 10
            let volumeView = MPVolumeView()
            volumeView.volumeSlider.value = 1.0
            
            player.play()
            UserDefaults.standard.setValue(false, forKey: "needsToAlarm")
        } catch {
            print("caught")
        }
    }
}

// Code to help volume changing
private extension MPVolumeView {
    var volumeSlider: UISlider {
        self.showsRouteButton = false
        self.showsVolumeSlider = false
        self.isHidden = true
        var slider = UISlider()
        for subview in self.subviews {
            if subview is UISlider {
                slider = subview as! UISlider
                slider.isContinuous = false
                (subview as! UISlider).value = 1
                return slider
            }
        }
        return slider
    }
}

extension AlarmPlayer: URLSessionDelegate {
    
}
