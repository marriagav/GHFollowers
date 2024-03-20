//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Miguel Arriaga Velasco on 20/03/24.
//

import Foundation

enum PersistanceActionType {
    case add
    case remove
}

enum PersistanceManager {
    private static let defaults = UserDefaults.standard

    enum Keys {
        static let favorites = "favorites"
    }

    static func updateWith(favorite: Follower, actionType: PersistanceActionType) throws {
        var favorites = try retrieveFavorites()
        switch actionType {
        case .add:
            guard !favorites.contains(favorite) else {
                throw GFError.alreadyInFavorites
            }
            favorites.append(favorite)
        case .remove:
            favorites.removeAll { follower in
                follower.login == favorite.login
            }
        }
        try save(favorites: favorites)
    }

    static func retrieveFavorites() throws -> [Follower] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            return favorites
        } catch {
            throw (GFError.unableToFavorite)
        }
    }

    static func save(favorites: [Follower]) throws {
        do {
            let encoder = JSONEncoder()
            let favorites = try encoder.encode(favorites)
            defaults.setValue(favorites, forKey: Keys.favorites)
        } catch {
            throw (GFError.unableToFavorite)
        }
    }

}
