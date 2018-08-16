//
//  MyAlarmViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage
import AVFoundation
import Alamofire

class MyAlarmViewController: UIViewController {

    var alarmSwitch = UISwitch()
    var alarmLabel = DatePickerLabel(initialTime: AlarmStore.shared.getLastAlarm())
    var tapToEdit = SmallTextLabel()
    
    let alarmScheduler = AlarmScheduler()
    
    var alarmTable = UITableView()
    var timePicker = UIDatePicker()
    
    var alarms = [Alarm]()
    
    var player: AVAudioPlayer?
    var playingButton: UIButton? {
        willSet {
            if self.playingButton != newValue {
                self.playingButton?.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AlarmStore.shared.get { (alarms) in
            self.alarms = alarms
            self.alarmTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Alarm"
        
        self.alarmLabel.font = UIFont(name: "DS-Digital", size: 64)
        self.alarmLabel.textColor = UIColor(named: "alarm-red")
        self.alarmLabel.text = "alarm off"
        self.alarmLabel.delegate = self
        
        self.alarmSwitch.addTarget(self, action: #selector(toggleAlarm(sender:)), for: .valueChanged)
        
        self.tapToEdit.text = "tap to edit"
        self.tapToEdit.textColor = UIColor(named: "alarm-red")
        
        self.alarmTable.delegate = self
        self.alarmTable.dataSource = self
        self.alarmTable.separatorStyle = .none
        self.alarmTable.rowHeight = 70
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(title: "+", style: .plain, target: self, action: #selector(addAlarm)), animated: true)
        
        self.view.addSubview(self.alarmSwitch)
        self.view.addSubview(self.alarmLabel)
        self.view.addSubview(self.tapToEdit)
        self.view.addSubview(self.alarmTable)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        
        self.alarmSwitch.centerXAnchor == self.view.centerXAnchor
        self.alarmSwitch.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 20
        
        self.alarmLabel.topAnchor == self.alarmSwitch.bottomAnchor + 20
        self.alarmLabel.centerXAnchor == self.view.centerXAnchor
        
        self.tapToEdit.centerXAnchor == self.view.centerXAnchor
        self.tapToEdit.topAnchor == self.alarmLabel.bottomAnchor
        
        self.alarmTable.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor
        self.alarmTable.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor
        self.alarmTable.trailingAnchor == self.view.safeAreaLayoutGuide.trailingAnchor
        self.alarmTable.topAnchor ==  self.tapToEdit.bottomAnchor + 40
    }
    
    @objc func addAlarm() {
        let vc = AddAlarmViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func toggleAlarm(sender: UISwitch) {
        if sender.isOn {
            self.alarmLabel.text = AlarmStore.shared.getLastAlarm()?.formatted ?? "TAP TO SET ALARM"
        } else {
            self.alarmLabel.text = "ALARM OFF"
        }
    }
    
    @objc func play(sender: UIButton) {
        let alarm = self.alarms[sender.tag]
        guard let url = URL(string: alarm.fileURL) else {
            print("Invalid URL")
            return
        }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = self.getDocumentsDirectory()
            documentsURL.appendPathComponent("play.m4a")
            return (documentsURL, [.removePreviousFile])
        }
        // just stop playing if already playing
        if self.player?.isPlaying ?? false {
            self.player?.stop()
            sender.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            self.alarmTable.reloadData()
            return
        }
        sender.setImage(#imageLiteral(resourceName: "stop-icon"), for: .normal)
        Alamofire.download(url, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                print("complete! time to play")
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    self.player = try AVAudioPlayer(contentsOf: destinationUrl, fileTypeHint: AVFileType.m4a.rawValue)
                    self.player?.delegate = self
                    guard let player = self.player else { return }
                    
                    player.play()
                    
                    self.playingButton = sender
                    
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension MyAlarmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarms.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Alarms"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarm = self.alarms[indexPath.row]
        
        let cell = AlarmTableViewCell(style: .default, reuseIdentifier: "Alarm")
        cell.nameLabel.text = alarm.name
        cell.userLabel.text = alarm.username
        
        cell.playButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        cell.playButton.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)
        cell.playButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "header-color")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: "header-text-color")
    }
}

extension MyAlarmViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playingButton?.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
    }
}

extension MyAlarmViewController: DatePickerDelegate {
    func timeChanged(time: Date) {
        self.alarmSwitch.isOn = true
    }
    
    func donePressed(time: Date) {
        print("User selected \(time.formatted)")
        self.alarmScheduler.scheduleAlarm(time: time)
    }
}
