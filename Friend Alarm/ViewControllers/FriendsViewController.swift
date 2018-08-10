//
//  FriendsViewController.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage
import Presentr

class FriendsViewController: UIViewController {
    
    var searchBar = UISearchBar()
    var friendsTable = UITableView()
    var isConnectedToFacebook = false
    
    var friends = [User]()
    var facebookFriends = [FacebookUser]()
    
    var isSearching = false {
        didSet {
            if isSearching {
                self.friendsTable.dataSource = self.searchResultsDataSource
            } else {
                self.friends = FriendStore.shared.getFriends()
                self.friendsTable.dataSource = self
            }
            self.friendsTable.reloadData()
        }
    }
    var searchResultsDataSource = SearchResultsTableViewDataSource(searchResults: [])
    var searchResults = [User]() {
        didSet {
            self.searchResultsDataSource.searchResults = self.searchResults
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Friends"
        
        self.friends = FriendStore.shared.getFriends()
        
        self.searchBar.searchBarStyle = .default
        self.searchBar.changeSearchBarColor(color: UIColor.black)
        self.searchBar.barTintColor = UIColor.init(named: "bar-color")
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.init(named: "tint-color")
        
        self.friendsTable.delegate = self
        self.friendsTable.dataSource = self
        self.friendsTable.separatorStyle = .none
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.friendsTable)
        
        if !UserStore.shared.hasRegisteredUsername() {
            let vc = PickAUsernameViewController()
            let presentr = Presentr(presentationType: .dynamic(center: .center))
            presentr.keyboardTranslationType = .moveUp
            self.customPresentViewController(presentr, viewController: vc, animated: true)
        }
        
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
            let friend = self.friends[indexPath.row]
            
            let cell = FriendCell(style: .default, reuseIdentifier: "FriendCell")
            cell.usernameLabel.text = friend.username
            return cell
        } else if indexPath.section == 1 {
            let facebookFriend = self.facebookFriends[indexPath.row]
            
            let cell = FacebookFriendCell(style: .default, reuseIdentifier: "FacebookFriendCell")
            cell.nameLabel.text = facebookFriend.name
            return cell
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

extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UserStore.shared.search(query: searchText) { (users) in
            guard let users = users else {
                return
            }
            self.searchResults = users
            self.friendsTable.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.isSearching = false
        searchBar.resignFirstResponder()
    }
}
