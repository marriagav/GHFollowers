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

    enum NetworkManagerError: Error {
        case invalidServerResponse
        case invalidURL
        case invalidData
    }

    private init() {}

    func getRequest(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerError.invalidServerResponse
        }
        return data
    }

    // With async/await
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        guard var url = URL(string: baseURL) else {
            throw NetworkManagerError.invalidURL
        }
        url.append(path: username)
        url.append(path: "followers")
        url.append(queryItems: [
            URLQueryItem(name: "per_page", value: usersPerPage.description),
            URLQueryItem(name: "page", value: page.description)
        ])

        let data = try await getRequest(url: url)

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let followers = try decoder.decode([Follower].self, from: data)
            return followers
        } catch {
            throw (NetworkManagerError.invalidData)
        }
    }

    // With callback
    func getFollowers(
        for username: String,
        page: Int,
        withCompletion completion: @escaping ([Follower]?, String?) -> Void
    ) {
        guard var url = URL(string: baseURL) else {
            completion(nil, "This username created an invalid request. Please try again.")
            return
        }
        url.append(path: username)
        url.append(path: "followers")
        url.append(queryItems: [
            URLQueryItem(name: "per_page", value: usersPerPage.description),
            URLQueryItem(name: "page", value: page.description)
        ])
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil, "Unable to complete your request. Please check your internet connection")
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "There was an error. Please try again later")
                return
            }

            guard let data = data else {
                completion(nil, "The data recieved from the server was invalid. Please try again.")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, "The data recieved from the server was invalid. Please try again.")
            }
        }

        task.resume()
    }
}

// MARK: - NetworkManager.NetworkManagerError + LocalizedError

extension NetworkManager.NetworkManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: "This url created an invalid request. Please try again.")
        case .invalidServerResponse:
            return String(localized: "The data recieved from the server was invalid. Please try again.")
        case .invalidData:
            return String(localized: "The data recieved from the server was invalid. Please try again.")
        }
    }
}
