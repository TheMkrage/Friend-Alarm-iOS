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

class AlarmPlayer: NSObject {
    static var shared = AlarmPlayer()
    private override init() {   }
    
    private var player: AVAudioPlayer? = AVAudioPlayer()
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func playAlarm(id: Int) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.duckOthers, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            let url = self.getDocumentsDirectory().appendingPathComponent("\(id).m4a")
        
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            guard let player = self.player else {
                return
            }
            player.numberOfLoops = 3
            let volumeView = MPVolumeView()
            volumeView.volumeSlider.value = 1.0
            
            player.play()
        } catch {
            NSLog("Audio Session error: \(error)")
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
