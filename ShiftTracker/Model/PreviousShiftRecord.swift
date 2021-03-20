//
//  PreviousShiftRecord.swift
//  ShiftTracker
//
//  Created by Runa Alam on 20/3/21.
//

import Foundation

struct ShiftRecordElement: Codable {
    let id: Int
    let start, end: String
    let startLatitude, startLongitude, endLatitude, endLongitude: String
    let image: String
}
typealias PreviousShiftRecord = [ShiftRecordElement]
