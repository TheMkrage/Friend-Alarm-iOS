//
//  UISearchBar+Extension.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 7/31/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//

import UIKit

// as UISearchBar extension
extension UISearchBar {
    func changeSearchBarColor(color : UIColor) {
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = color
        }
    }
}
