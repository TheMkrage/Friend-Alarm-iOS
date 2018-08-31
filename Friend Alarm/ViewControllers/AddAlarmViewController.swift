//
//  AddAlarmViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/6/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage
import AVFoundation
import JGProgressHUD

protocol AlarmCreatedDelegate {
    func alarmCreated(alarm: Alarm)
}

class AddAlarmViewController: UIViewController {

    // Recording
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer?
    
    // View
    var nameLabel = TitleLabel()
    var nameField = UITextField()
    
    var alarmLabel = TitleLabel()
    var alarmDescriptionLabel = SmallTextLabel()
    
    var recordButtonView = UIView()
    var recordButtonLabel = UILabel()
    var recordButtonImage = UIImageView()
    
    var previewLabel = TitleLabel()
    var previewPlayButton = UIButton()
    
    var createButton = UIButton()
    
    var alarmCreatedDelegate: AlarmCreatedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(named: "background-color")

        self.nameLabel.text = "Name"
        self.nameField.attributedPlaceholder = NSAttributedString(string:"ex. Morning Mayhem", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(named: "tint-color") as Any])
        self.nameField.layer.cornerRadius = 5
        
        self.alarmLabel.text = "Alarm"
        self.alarmDescriptionLabel.text = "Make sure it could wake somebody up!"
        
        self.recordButtonView.backgroundColor = UIColor.init(named: "button-text-color")
        self.recordButtonImage.image = #imageLiteral(resourceName: "record")
        self.recordButtonLabel.textColor = UIColor.init(named: "tint-color")
        self.recordButtonLabel.text = "Record"
        self.recordButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countdownAndRecord)))
        
        self.recordButtonView.addSubview(self.recordButtonLabel)
        self.recordButtonView.addSubview(self.recordButtonImage)
        
        self.previewLabel.text = "Preview"
        self.previewPlayButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        self.previewPlayButton.addTarget(self, action: #selector(playRecordedAudio), for: .touchUpInside)
        
        self.createButton.backgroundColor = UIColor(named: "button-color")
        self.createButton.setTitle("Create", for: .normal)
        self.createButton.setTitleColor(UIColor(named: "button-text-color"), for: .normal)
        self.createButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        self.createButton.layer.cornerRadius = 17.5
        self.createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(close))
        
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.nameField)
        self.view.addSubview(self.alarmLabel)
        self.view.addSubview(self.alarmDescriptionLabel)
        self.view.addSubview(self.recordButtonView)
        self.view.addSubview(self.previewLabel)
        self.view.addSubview(self.previewPlayButton)
        self.view.addSubview(self.createButton)
        
        // Recording Setup
        self.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try self.recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try self.recordingSession.setActive(true)
            self.recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        self.setupConstraints()
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func create() {
        if self.audioRecorder != nil && self.audioRecorder.isRecording {
            audioRecorder.stop()
            audioRecorder = nil
        }
        guard let name = self.nameField.text else {
            self.alert(title: "Oops!", message: "Please give the alarm a name")
            return
        }
        let data = try? Data(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        AlarmStore.shared.create(audioData: data, name: name, duration: 1) { (alarm) in
            hud.dismiss(animated: true)
            if let alarm = alarm {
                self.alarmCreatedDelegate?.alarmCreated(alarm: alarm)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Audio Recording
    @objc func countdownAndRecord() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    // returns nil if have no recorded yet
    func getRecordedLength() -> Int? {
        let audioAsset = AVURLAsset.init(url: self.getAudioFileURL(), options: nil)
        let duration = audioAsset.duration
        print("dur \(duration)")
        print("dur2 \(CMTimeGetSeconds(duration))")
        return Int(CMTimeGetSeconds(duration))
    }
    
    private func getAudioFileURL() -> URL {
        print(getDocumentsDirectory().appendingPathComponent("recording.m4a"))
        return getDocumentsDirectory().appendingPathComponent("recording.m4a")
    }
    
    func startRecording() {
        let audioFilename = self.getAudioFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey:44100,
            AVNumberOfChannelsKey:2,
            AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue,
        ]
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            if audioRecorder.prepareToRecord() {
                audioRecorder.record()
            } else {
                print("not ready to record")
            }
            self.recordButtonImage.image = #imageLiteral(resourceName: "stop-record")
            self.recordButtonLabel.text = "Tap to Stop"
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        self.recordButtonImage.image = #imageLiteral(resourceName: "record")
        if success {
            self.recordButtonLabel.text = "Tap to Re-record"
        } else {
            self.recordButtonLabel.text = "Tap to Record"
        }
    }
    
    @objc func playRecordedAudio() {
        // just stop playing if already playing
        if player?.isPlaying ?? false {
            player?.stop()
            self.previewPlayButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: self.getAudioFileURL(), fileTypeHint: AVFileType.m4a.rawValue)
            player?.delegate = self
            guard let player = player else { return }
            
            player.play()
            self.previewPlayButton.setImage(#imageLiteral(resourceName: "stop-icon"), for: .normal)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setupConstraints() {
        self.nameLabel.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 10
        self.nameLabel.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor + 20
        
        self.nameField.topAnchor == self.nameLabel.bottomAnchor + 10
        self.nameField.leadingAnchor == self.view.leadingAnchor + 20
        self.nameField.trailingAnchor == self.view.trailingAnchor - 20
        self.nameField.heightAnchor == 26
        
        self.alarmLabel.topAnchor == self.nameField.bottomAnchor + 20
        self.alarmLabel.leadingAnchor == self.view.leadingAnchor + 20
        
        self.alarmDescriptionLabel.topAnchor == self.alarmLabel.bottomAnchor
        self.alarmDescriptionLabel.leadingAnchor == self.view.leadingAnchor + 20
        
        self.recordButtonView.topAnchor == self.alarmDescriptionLabel.bottomAnchor + 16
        self.recordButtonView.trailingAnchor == self.view.trailingAnchor - 20
        self.recordButtonView.heightAnchor == self.recordButtonView.widthAnchor * 0.5
        self.recordButtonView.leadingAnchor == self.view.leadingAnchor + 20
        
        self.recordButtonImage.centerAnchors == self.recordButtonView.centerAnchors
        self.recordButtonLabel.bottomAnchor == self.recordButtonView.bottomAnchor - 15
        self.recordButtonLabel.centerXAnchor == self.recordButtonView.centerXAnchor
        
        self.previewLabel.topAnchor == self.recordButtonView.bottomAnchor + 28
        self.previewLabel.centerXAnchor == self.view.centerXAnchor
        
        self.previewPlayButton.topAnchor == self.previewLabel.bottomAnchor + 15
        self.previewPlayButton.centerXAnchor == self.view.centerXAnchor
        
        self.createButton.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor - 40
        self.createButton.centerXAnchor == self.view.centerXAnchor
        self.createButton.widthAnchor == 190
        self.createButton.heightAnchor == 35
    }
}

extension AddAlarmViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension AddAlarmViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.previewPlayButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
    }
}
