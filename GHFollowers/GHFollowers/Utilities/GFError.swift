//
//  GFError.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 11/03/24.
//

import Foundation

enum GFError: Error {
    case invalidUsername
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case unableToFavorite
    case alreadyInFavorites
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
        case .invalidURL:
            return String(localized: "The request url is invalid. Please try again.")
        case .unableToFavorite:
            return String(localized: "There was an error favoriting this user. Please try again.")
        case .alreadyInFavorites:
            return String(localized: "You've already favorited this user.")
        }
    }
}
