//
//  SFSymbols.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 13/03/24.
//

import UIKit

enum SFSymbols {
    case location
    case repos
    case gists
    case followers
    case following
    case alert
    case person
    case people
    case star
    case personSlash

    var symbolImage: UIImage? {
        switch self {
        case .location:
            return UIImage(systemName: "mappin.and.ellipse")
        case .repos:
            return UIImage(systemName: "folder")
        case .gists:
            return UIImage(systemName: "text.alignleft")
        case .followers:
            return UIImage(systemName: "heart")
        case .following:
            return UIImage(systemName: "person.2")
        case .alert:
            return UIImage(systemName: "checkmark.circle")
        case .person:
            return UIImage(systemName: "person")
        case .people:
            return UIImage(systemName: "person.3")
        case .star:
            return UIImage(systemName: "star")
        case .personSlash:
            return UIImage(systemName: "person.slash")
        }
    }
}
