//
//  Date+Extension.swift
//  Friend Alarm
//
//  Created by Matthew Krager on 8/16/18.
//  Copyright © 2018 Matthew Krager. All rights reserved.
//
import UIKit

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return  formatter.string(from: self)
    }
}

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
