//
//  User.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 10/03/24.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var followers: Int
    var following: Int
    var createdAt: String
    var bio: String?
}
