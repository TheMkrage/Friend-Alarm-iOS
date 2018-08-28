//
//  AddAlarmForFriendViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/24/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class AddAlarmForFriendViewController: AudioPlayingViewController {
    
    var friend: User!
    var alarms = [Alarm]()
    lazy var selectedAlarm = self.alarms.first
    
    // View
    var newAlarmButton = UIButton()
    
    var highPriorityLabel = TitleLabel()
    var highPriorityDescriptionLabel = SmallTextLabel()
    var highPrioritySwitch = UISwitch()
    
    var secretLabel = TitleLabel()
    var secretDescriptionLabel = SmallTextLabel()
    var secretSwitch = UISwitch()
    
    var alarmTable = UITableView()
    
    var addButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        AlarmStore.shared.get { (alarms) in
            self.alarms = alarms
            self.alarmTable.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Alarm for \(self.friend.username)"
        self.view.backgroundColor = UIColor.init(named: "background-color")
        
        self.newAlarmButton.backgroundColor = UIColor(named: "button-color")
        self.newAlarmButton.setTitle("New Alarm", for: .normal)
        self.newAlarmButton.setTitleColor(UIColor(named: "button-text-color"), for: .normal)
        self.newAlarmButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        self.newAlarmButton.layer.cornerRadius = 16
        self.newAlarmButton.addTarget(self, action: #selector(moveToNewAlarm), for: .touchUpInside)
        
        self.highPriorityLabel.text = "High Priority"
        self.highPriorityDescriptionLabel.text = "When on, your alarm will be used as soon as possible"
        self.highPriorityDescriptionLabel.numberOfLines = 0
        
        self.secretLabel.text = "Secret Alarm"
        self.secretDescriptionLabel.text = "Don't let your friend listen to the alarm until it wakes them up!"
        self.secretDescriptionLabel.numberOfLines = 0
        
        self.alarmTable.delegate = self
        self.alarmTable.dataSource = self
        self.alarmTable.separatorStyle = .none
        self.alarmTable.rowHeight = 70
        
        self.addButton.backgroundColor = UIColor(named: "button-color")
        self.addButton.setTitle("Add to Queue", for: .normal)
        self.addButton.setTitleColor(UIColor(named: "button-text-color"), for: .normal)
        self.addButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        self.addButton.layer.cornerRadius = 25
        self.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        self.view.addSubview(self.newAlarmButton)
        self.view.addSubview(self.highPriorityLabel)
        self.view.addSubview(self.highPriorityDescriptionLabel)
        self.view.addSubview(self.highPrioritySwitch)
        self.view.addSubview(self.secretLabel)
        self.view.addSubview(self.secretDescriptionLabel)
        self.view.addSubview(self.secretSwitch)
        
        self.view.addSubview(self.alarmTable)
        self.view.addSubview(self.addButton)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(close))

        self.setupConstraints()
    }
    
    @objc func moveToNewAlarm() {
        let vc = AddAlarmViewController()
        vc.alarmCreatedDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func add() {
        guard let alarmId = self.selectedAlarm?.id else {
            self.alert(title: "Select an alarm!", message: "Select or create a new alarm for your friend!")
            return
        }
        FriendStore.shared.addAlarm(friendId: self.friend.id, isSecret: self.secretSwitch.isOn, isHighPriority: self.highPrioritySwitch.isOn, alarmId: alarmId) { (isSuccess) in
            print(isSuccess)
            print("uploaded")
            if isSuccess {
                self.close()
            }
        }
    }
    
    @objc func play(sender: UIButton) {
        
        // just stop playing if already playing
        if self.player?.isPlaying ?? false {
            self.player?.stop()
            sender.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            self.alarmTable.reloadData()
            return
        }
        sender.setImage(#imageLiteral(resourceName: "stop-icon"), for: .normal)
        self.playOrDownload(alarm: self.alarms[sender.tag], sender: sender)
        self.playingButton = sender
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupConstraints() {
        self.newAlarmButton.centerXAnchor == self.view.centerXAnchor
        self.newAlarmButton.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + 25
        self.newAlarmButton.widthAnchor == 195
        self.newAlarmButton.heightAnchor == 32
        
        // High Priority Label
        self.highPriorityLabel.topAnchor == self.newAlarmButton.bottomAnchor + 21
        self.highPriorityLabel.leadingAnchor == self.view.leadingAnchor + 20
        
        self.highPriorityDescriptionLabel.topAnchor == self.highPriorityLabel.bottomAnchor
        self.highPriorityDescriptionLabel.leadingAnchor == self.view.leadingAnchor + 20
        self.highPriorityDescriptionLabel.trailingAnchor == self.highPrioritySwitch.leadingAnchor - 10
        
        self.highPrioritySwitch.centerYAnchor == self.highPriorityLabel.bottomAnchor
        self.highPrioritySwitch.trailingAnchor == self.view.trailingAnchor - 20
        self.highPrioritySwitch.widthAnchor == 51
        
        // Secret row
        self.secretLabel.topAnchor == self.highPrioritySwitch.bottomAnchor + 21
        self.secretLabel.leadingAnchor == self.view.leadingAnchor + 20
        
        self.secretDescriptionLabel.topAnchor == self.secretLabel.bottomAnchor
        self.secretDescriptionLabel.leadingAnchor == self.view.leadingAnchor + 20
        self.secretDescriptionLabel.trailingAnchor == self.secretSwitch.leadingAnchor - 10
        
        self.secretSwitch.centerYAnchor == self.secretLabel.bottomAnchor
        self.secretSwitch.trailingAnchor == self.view.trailingAnchor - 20
        self.secretSwitch.widthAnchor == 51
        
        self.alarmTable.leadingAnchor == self.view.leadingAnchor
        self.alarmTable.trailingAnchor == self.view.trailingAnchor
        self.alarmTable.topAnchor == self.secretDescriptionLabel.bottomAnchor + 25
        
        self.addButton.topAnchor == self.alarmTable.bottomAnchor + 27
        self.addButton.centerXAnchor == self.view.centerXAnchor
        self.addButton.heightAnchor == 50
        self.addButton.widthAnchor == 225
        self.addButton.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor - 23
    }
}

extension AddAlarmForFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarms.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Choose an Alarm Below"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "header-color")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: "header-text-color")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarm = self.alarms[indexPath.row]
        
        let cell = AlarmTableViewCell(style: .default, reuseIdentifier: "Alarm")
        cell.nameLabel.text = alarm.name
        cell.userLabel.text = alarm.username
        
        if self.selectedAlarm == alarm {
            cell.alarmIcon.image = #imageLiteral(resourceName: "checkmark")
            cell.alarmIcon.isHidden = false
        } else {
            cell.alarmIcon.isHidden = true
        }
        
        cell.playButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        cell.playButton.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)
        cell.playButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAlarm = self.alarms[indexPath.row]
        tableView.reloadData()
    }
}

extension AddAlarmForFriendViewController: AlarmCreatedDelegate {
    func alarmCreated(alarm: Alarm) {
        self.alarms.append(alarm)
        self.alarmTable.reloadData()
    }
}
