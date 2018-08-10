//
//  SearchResultsTableViewDelegate.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/3/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

class SearchResultsTableViewDataSource: NSObject, UITableViewDataSource {
    
    var searchResults = [User]()
    var table: UITableView!
    
    init(searchResults: [User], table: UITableView) {
        self.searchResults = searchResults
        self.table = table
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.searchResults[indexPath.row]
        let cell = AddFriendCell(style: .default, reuseIdentifier: "AddFriend")
        if FriendStore.shared.isFriend(user: user) {
            cell.addFriendButton.setTitle("-", for: .normal)
        } else {
            cell.addFriendButton.setTitle("+", for: .normal)
        }
        cell.usernameLabel.text = user.username
        cell.addFriendButton.tag = indexPath.row
        cell.addFriendButton.addTarget(self, action: #selector(toggleFriend(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func toggleFriend(sender: UIButton) {
        let user = self.searchResults[sender.tag]
        FriendStore.shared.toggleFriend(user: user)
        self.table.reloadData()
    }
}
