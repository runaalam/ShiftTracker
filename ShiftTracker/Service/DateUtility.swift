//
//  Utility.swift
//  ShiftTracker
//
//  Created by Runa Alam on 19/3/21.
//

import Foundation
import UIKit

struct DateUtility {
    
    //Get current date and time in "yyyy-MM-dd'T'HH:mm:ssZZZZZ" formate.

    static func getCurrentDateTimeString() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date())
    }
    
    static func getDateFromISO8601(string: String, formate: String)-> String{
        let isoFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from: string)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let dateStr = dateFormatter.string(from: date!)
        return dateStr
    }
    
    //
    static func getDate(dateStr: String)-> String {
        return DateUtility.getDateFromISO8601(string: dateStr, formate: Constants.Formate_Shift_Date)
    }
    
    static func getShiftDuration(start:String, end:String)-> String{
        var duration = "Worked:  " + DateUtility.getDateFromISO8601(string: start, formate: Constants.Formate_Shift_Time) + " - "
        if end == "" {
            duration = duration + "In progress"
        } else {
            duration = duration + DateUtility.getDateFromISO8601(string: end, formate: Constants.Formate_Shift_Time)
        }
        return duration
    }
}
