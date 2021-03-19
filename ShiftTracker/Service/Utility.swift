//
//  Utility.swift
//  ShiftTracker
//
//  Created by Runa Alam on 19/3/21.
//

import Foundation

struct Utility {
    static func getCurrentDateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.string(from: Date())
    }
}
