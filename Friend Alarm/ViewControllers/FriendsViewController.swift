//
//  FriendsViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class FriendsViewController: UIViewController {
    
    var searchBar = UISearchBar()
    var friendsTable = UITableView()
    var isConnectedToFacebook = false
    
    var friends = [User]()
    var facebookFriends = [FacebookUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Friends"
        
        self.friends.append(User())
        self.friends.append(User())
        self.friends.append(User())
        self.facebookFriends.append(FacebookUser())
        self.facebookFriends.append(FacebookUser())
        self.facebookFriends.append(FacebookUser())
        
        self.searchBar.searchBarStyle = .default
        self.searchBar.changeSearchBarColor(color: UIColor.black)
        self.searchBar.barTintColor = UIColor.init(named: "bar-color")
        
        self.friendsTable.delegate = self
        self.friendsTable.dataSource = self
        self.friendsTable.separatorStyle = .none
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.friendsTable)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.searchBar.topAnchor == self.view.safeAreaLayoutGuide.topAnchor
        self.searchBar.leadingAnchor == self.view.leadingAnchor
        self.searchBar.trailingAnchor == self.view.trailingAnchor
        
        self.friendsTable.topAnchor == self.searchBar.bottomAnchor
        self.friendsTable.leadingAnchor == self.view.leadingAnchor
        self.friendsTable.trailingAnchor == self.view.trailingAnchor
        self.friendsTable.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isConnectedToFacebook ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.friends.count
        } else if section == 1 {
            return self.facebookFriends.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = FriendCell(style: .default, reuseIdentifier: "FriendCell")
        } else if indexPath.section == 1 {
            let cell = FacebookFriendCell(style: .default, reuseIdentifier: "FacebookFriendCell")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Added Friends"
        } else if section == 1 {
            return "Facebook Friends"
        } else {
            return "error"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "header-color")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: "header-text-color")
    }
}
