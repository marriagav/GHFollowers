//
//  GFError.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 11/03/24.
//

import Foundation

enum GFError: Error {
    case invalidUsername
    case unableToComplete
    case invalidResponse
    case invalidData
}

// MARK: LocalizedError

extension GFError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidUsername:
            return String(localized: "This username creted an invalid request. Please try again.")
        case .unableToComplete:
            return String(localized: "Unable to complete your request. Please check your internet connection.")
        case .invalidResponse:
            return String(localized: "Invalid response from the server. Please try again.")
        case .invalidData:
            return String(localized: "The data recieved from the server was invalid. Please try again.")
        }
    }
}
