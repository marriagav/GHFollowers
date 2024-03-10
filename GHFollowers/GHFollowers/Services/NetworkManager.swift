//
//  NetwrokManager.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 10/03/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    let usersPerPage = 100

    private init() {}

    func getFollowers(for username: String, page: Int, completion _: @escaping ([Follower]?, String?)) {
        let endpoint = baseURL + "\(username)/followers?per_page=\(usersPerPage)&page=\(page)"

        guard var url = URL(string: endpoint) else {}

        url.append(queryItems: [
            URLQueryItem(name: "per_page", value: usersPerPage),
            URLQueryItem(name: "page", value: page)
        ])
    }
}
