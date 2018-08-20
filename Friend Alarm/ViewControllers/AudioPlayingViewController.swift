//
//  AudioPlayingViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/19/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import AVKit
import Alamofire

class AudioPlayingViewController: UIViewController {
    var player: AVAudioPlayer?
    
    func playOrDownload(alarm: Alarm, sender: UIButton) {
        guard let url = URL(string: alarm.fileURL) else {
            print("Invalid URL")
            return
        }
        var urlToAudioFile = self.getDocumentsDirectory()
        urlToAudioFile.appendPathComponent("\(alarm.id).m4a")

        if FileManager.default.fileExists(atPath: urlToAudioFile.path) {
            self.play(url: urlToAudioFile, sender: sender, fallbackUrl: url, fallbackDestinationURL: urlToAudioFile)
        } else {
            self.downloadAndPlay(url: url, urlToAudioFile: urlToAudioFile, sender: sender)
        }
    }
    
    private func downloadAndPlay(url: URL, urlToAudioFile: URL, sender: UIButton) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (urlToAudioFile, [.removePreviousFile])
        }
        
        Alamofire.download(url, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                self.play(url: urlToAudioFile, sender: sender)
            }
        }
    }
    
    private func play(url: URL, sender: UIButton, fallbackUrl: URL? = nil, fallbackDestinationURL: URL? = nil) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            self.player?.delegate = self as? AVAudioPlayerDelegate
            guard let player = self.player else { return }
            
            player.play()
        } catch let error {
            if let fallback = fallbackUrl, let fallbackDestination = fallbackDestinationURL {
                self.downloadAndPlay(url: fallback, urlToAudioFile: fallbackDestination, sender: sender)
            }
            print(error.localizedDescription)
        }
    }
}
