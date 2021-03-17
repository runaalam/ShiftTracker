//
//  Shift.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import Foundation

class Shift {
    
    let time : String
    let latitude : String
    let longitude : String
    
    init(time: String, latitude: String, longitude: String) {
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func createJsonData()-> String {
        let jsonText = "{\"time\": \"\(self.time)\", \"latitude\": \"\(self.latitude)\", \"longitude\": \"\(self.longitude)\"}"
        return jsonText
    }
}
