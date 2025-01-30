//
//  FavoritesManager.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 30/01/25.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private let favoritesKey = "favoriteEpisodes"
    
    private init() {}

    func getFavorites() -> [Episode] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let episodes = try? JSONDecoder().decode([Episode].self, from: data) else {
            return []
        }
        return episodes
    }

    func isFavorite(_ episode: Episode) -> Bool {
        return getFavorites().contains { $0.audioURL == episode.audioURL }
    }

    func toggleFavorite(_ episode: Episode) {
        var favorites = getFavorites()
        
        if let index = favorites.firstIndex(where: { $0.audioURL == episode.audioURL }) {
            favorites.remove(at: index)
        } else {
            favorites.append(episode)
        }
        
        saveToUserDefaults(favorites)
        NotificationCenter.default.post(name: .didUpdateFavorites, object: nil)
    }

    private func saveToUserDefaults(_ episodes: [Episode]) {
        if let data = try? JSONEncoder().encode(episodes) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}

extension NSNotification.Name {
    static let didUpdateFavorites = NSNotification.Name("didUpdateFavorites")
}

