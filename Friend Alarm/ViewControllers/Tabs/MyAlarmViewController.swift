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
import Presentr

class MyAlarmViewController: AudioPlayingViewController {

    var alarmSwitch = UISwitch()
    var alarmLabel = DatePickerLabel(initialTime: AlarmStore.shared.getLastAlarm())
    var tapToEdit = SmallTextLabel()
    
    var alarmTable = UITableView()
    var timePicker = UIDatePicker()
    
    var alarms = [Alarm]()
    var selectedAlarm: Alarm?
    
    override func viewWillAppear(_ animated: Bool) {
        AlarmStore.shared.get { (alarms) in
            self.alarms = alarms.reversed()
            self.alarmTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Alarm"
        
        self.alarmLabel.font = UIFont(name: "DS-Digital", size: 64)
        self.alarmLabel.textColor = UIColor(named: "alarm-red")
        self.alarmLabel.delegate = self
        
        self.alarmSwitch.isOn = AlarmStore.shared.isAlarmSet()
        self.alarmSwitch.addTarget(self, action: #selector(toggleAlarm(sender:)), for: .valueChanged)
        
        if self.alarmSwitch.isOn {
            if let time = AlarmStore.shared.getLastAlarm() {
                let formattedTime = time.formatted
                self.alarmLabel.text = formattedTime
            } else {
                self.alarmLabel.text = "TAP TO SET"
            }
        } else {
            self.alarmLabel.text = "ALARM OFF"
        }
        
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
        
        if !UserStore.shared.hasRegisteredUsername() {
            let vc = PickAUsernameViewController()
            let presentr = Presentr(presentationType: .dynamic(center: .center))
            presentr.keyboardTranslationType = .moveUp
            self.customPresentViewController(presentr, viewController: vc, animated: true)
        }
        
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
            
            guard let time = AlarmStore.shared.getLastAlarm() else {
                self.alarmLabel.text = "TAP TO SET ALARM"
                return
            }
            let formattedTime = time.formatted
            self.alarmLabel.text = formattedTime
            AlarmStore.shared.turnAlarmOn(time: time, alarm: self.selectedAlarm)
        } else {
            self.alarmLabel.text = "ALARM OFF"
            AlarmStore.shared.turnAlarmOff()
        }
    }
    
    @objc func play(sender: UIButton) {
        let alarm = self.alarms[sender.tag]
        if alarm.isSecret {
            self.alert(title: "This alarm is a secret!", message: "\(alarm.username) wants you to hear this alarm in the morning, not now!" )
            return
        }
        // just stop playing if already playing
        if self.player?.isPlaying ?? false {
            self.player?.stop()
            sender.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            self.alarmTable.reloadData()
            return
        }
        sender.setImage(#imageLiteral(resourceName: "stop-icon"), for: .normal)
        self.playOrDownload(alarm: alarm, sender: sender)
        self.playingButton = sender
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

extension MyAlarmViewController: DatePickerDelegate {
    func timeChanged(time: Date) {
        self.alarmSwitch.isOn = true
    }
    
    func donePressed(time: Date) {
        print("User selected \(time.formatted)")
        AlarmStore.shared.turnAlarmOn(time: time, alarm: self.selectedAlarm)
    }
}
