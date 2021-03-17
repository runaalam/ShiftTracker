//
//  ErrorResponse.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case errorMessage = "error"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return errorMessage
    }
}
