//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/17/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {

    enum Keys {
        static let favorites = "favorites"
    }
    
    static private let defaults = UserDefaults.standard
    
    
    static func update(with favorite: Follower, actionType: PersistenceActionType, completed: @escaping(GFError?) -> Void) {
        
        retrieveFavorites { (result) in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                
                case .remove:
                    favorites.removeAll { $0 == favorite }
                }
                
                completed((save(favorites: favorites)))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveFavorites(completed: @escaping(Result<[Follower], GFError>) -> Void) {
        
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([])) // Return an empty array to show there are no favorites
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
       } catch {
            completed(.failure(.unableToFavorite))
       }
    }
    
    
    static func save(favorites: [Follower]) -> GFError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return GFError.unableToFavorite
        }
    }
}
