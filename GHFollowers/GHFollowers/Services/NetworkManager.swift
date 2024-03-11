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

    func getRequest(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        return data
    }

    func addPaginationParams(to url: URL, page: Int) -> URL {
        return url.appending(queryItems: [
            URLQueryItem(name: "per_page", value: usersPerPage.description),
            URLQueryItem(name: "page", value: page.description)
        ])
    }

    // With async/await
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        guard var url = URL(string: baseURL) else {
            throw GFError.invalidUsername
        }
        url.append(path: username)
        url.append(path: "followers")
        url = addPaginationParams(to: url, page: page)

        let data = try await getRequest(url: url)

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let followers = try decoder.decode([Follower].self, from: data)
            return followers
        } catch {
            throw (GFError.invalidData)
        }
    }

    // With callback
    func getFollowers(
        for username: String,
        page: Int,
        withCompletion completion: @escaping (Result<[Follower], GFError>) -> Void
    ) {
        guard var url = URL(string: baseURL) else {
            completion(.failure(GFError.invalidUsername))
            return
        }
        url.append(path: username)
        url.append(path: "followers")
        url = addPaginationParams(to: url, page: page)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(GFError.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(GFError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(GFError.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(GFError.invalidData))
            }
        }

        task.resume()
    }
}
