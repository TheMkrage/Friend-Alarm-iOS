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
    var timeUntilAlarmLabel = UILabel()
    var untilItsTimeToWakeUpLabel = SmallTextLabel()
    
    let alarmScheduler = AlarmScheduler()
    
    var alarmTable = UITableView()
    
    var alarms = [Alarm]()
    
    var player: AVAudioPlayer?
    var playingButton: UIButton? {
        willSet {
            self.playingButton?.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
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
        
        self.timeUntilAlarmLabel.font = UIFont(name: "DS-Digital", size: 64)
        self.timeUntilAlarmLabel.textColor = UIColor(named: "alarm-red")
        self.timeUntilAlarmLabel.text = "alarm off"
        
        self.untilItsTimeToWakeUpLabel.text = "until it's time to wake up"
        self.untilItsTimeToWakeUpLabel.textColor = UIColor(named: "alarm-red")
        
        self.alarmTable.delegate = self
        self.alarmTable.dataSource = self
        self.alarmTable.separatorStyle = .none
        self.alarmTable.rowHeight = 70
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(title: "+", style: .plain, target: self, action: #selector(addAlarm)), animated: true)
        
        self.view.addSubview(self.alarmSwitch)
        self.view.addSubview(self.timeUntilAlarmLabel)
        self.view.addSubview(self.untilItsTimeToWakeUpLabel)
        self.view.addSubview(self.alarmTable)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.alarmSwitch.centerXAnchor == self.view.centerXAnchor
        self.alarmSwitch.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 20
        
        self.timeUntilAlarmLabel.topAnchor == self.alarmSwitch.bottomAnchor + 20
        self.timeUntilAlarmLabel.centerXAnchor == self.view.centerXAnchor
        
        self.untilItsTimeToWakeUpLabel.centerXAnchor == self.view.centerXAnchor
        self.untilItsTimeToWakeUpLabel.topAnchor == self.timeUntilAlarmLabel.bottomAnchor
        
        self.alarmTable.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor
        self.alarmTable.leadingAnchor == self.view.safeAreaLayoutGuide.leadingAnchor
        self.alarmTable.trailingAnchor == self.view.safeAreaLayoutGuide.trailingAnchor
        self.alarmTable.topAnchor ==  self.untilItsTimeToWakeUpLabel.bottomAnchor + 40
    }
    
    @objc func addAlarm() {
        let vc = AddAlarmViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
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
        
        Alamofire.download(url, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                print("complete! time to play")
                // just stop playing if already playing
                if self.player?.isPlaying ?? false {
                    self.player?.stop()
                    sender.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
                    return
                }
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    self.player = try AVAudioPlayer(contentsOf: destinationUrl, fileTypeHint: AVFileType.m4a.rawValue)
                    self.player?.delegate = self
                    guard let player = self.player else { return }
                    
                    player.play()
                    sender.setImage(#imageLiteral(resourceName: "stop-icon"), for: .normal)
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
