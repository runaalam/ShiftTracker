//
//  Constants.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import Foundation

struct Constants {
    
    static let Url_Base = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    static let sha1 = "be7e10f6dff6bc0e03236ed22e76604329b14d8e"
    static let Header_Authorization = "Deputy " + sha1
    static let Header_Content_Type = "application/json"
    
    static let Url_Shift_Start = "/shift/start"
    static let Url_Shift_End = "/shift/end"
    static let Url_Previus_Shifts = "/shifts"
    
    static let Message_Shift_Started = "Start shift - All good"
    static let Message_Shift_Ended = "End shift - All good"
    static let Message_Shift_Inprogress = "Shift already in progress"
    static let Message_Shift_Not_Inprogress = "No shift started to be closed"
    
    static let Formate_Shift_Date = "dd MMM YYYY"
    static let Formate_Shift_Time = "h:mm a"
}

