//
//  DateFormatter+Extensions.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 22/01/2021.
//

import Foundation

extension DateFormatter {
    static var `default`: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }
    
    static var medium: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .medium
        return formatter
    }
}
