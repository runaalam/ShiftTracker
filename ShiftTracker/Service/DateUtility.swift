//
//  Utility.swift
//  ShiftTracker
//
//  Created by Runa Alam on 19/3/21.
//

import Foundation
import UIKit

struct DateUtility {
    
    //Get current date and time(as srting) in "yyyy-MM-dd'T'HH:mm:ssZZZZZ"/ISO8601 DateFormatter formate.
    static func getCurrentDateTimeString() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date())
    }
    
    // From a date string that contain ISO8601 DateFormate, get a date/time string determined by the caller
    static func getDateFromISO8601(string: String, formate: String)-> String{
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: string){
            
            print(date as Any)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formate
            let dateStr = dateFormatter.string(from: date)
            print("======")
            print(dateStr as Any)
            return dateStr
        } else {
            return ""
        }
        
        
    }
    
    //This method call getDateFromISO8601() to return date string only
    static func getDate(dateStr: String)-> String {
        return DateUtility.getDateFromISO8601(string: dateStr, formate: Constants.Formate_Shift_Date)
    }
    
    //This method call getDateFromISO8601() to return display string that has start and end time status
    static func getShiftDuration(start:String, end:String)-> String{
        var duration = ""
        if start == "" {
            duration = duration + "Worked:  " + DateUtility.getDateFromISO8601(string: start, formate: Constants.Formate_Shift_Time) + " - "
        }
        
        if end == "" {
            duration = duration + "In progress"
        } else {
            duration = duration + DateUtility.getDateFromISO8601(string: end, formate: Constants.Formate_Shift_Time)
        }
        return duration
    }
}
