//
//  User.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 10/03/24.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let followers: Int
    let following: Int
    let createdAt: String
}
