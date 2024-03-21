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
        }
    }
}
