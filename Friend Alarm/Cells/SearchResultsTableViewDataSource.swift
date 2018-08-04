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
    
    init(searchResults: [User]) {
        self.searchResults = searchResults
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddFriendCell(style: .default, reuseIdentifier: "AddFriend")
        cell.usernameLabel.text = self.searchResults[indexPath.row].username
        cell.addFriendButton.tag = indexPath.row
        cell.addFriendButton.addTarget(self, action: #selector(toggleFriend(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func toggleFriend(sender: UIButton) {
        
    }
}
