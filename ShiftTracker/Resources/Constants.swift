//
//  Constants.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import Foundation

struct Constants {
    
    static let URL_BASE = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    static let SHA1 = "be7e10f6dff6bc0e03236ed22e76604329b14d8e"
    static let HEADER_AUTHORISATION = "Deputy " + SHA1
    static let HEADER_CONTENT_TYPE = "application/json"
    
    static let URL_SHIFT_START = "/shift/start"
    static let URL_SHIFT_END = "/shift/end"
    static let URL_PREVIOUS_SHIFTS = "/shifts"
    
    static let MESSAGE_SHIFT_STARTED = "Start shift - All good"
    static let MESSAGE_SHIFT_ENDED = "End shift - All good"
    static let MESSAGE_SHIFT_INPROGRESS = "Shift already in progress"
    static let MESSAGE_SHIFT_NOT_INPROGRESS = "No shift started to be closed"
    static let MESSAGE_REQUEST_FAIL = "Woof woof - Bad baad baaad shift"
    
    static let FORMAT_SHIFT_DATE = "dd MMM YYYY"
    static let FORMAT_SHIFT_TIME = "h:mm a"
}

