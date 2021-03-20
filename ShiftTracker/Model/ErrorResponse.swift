//
//  ErrorResponse.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import Foundation

struct ErrorResponse: Codable {
    
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "message"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return errorMessage
    }
}
