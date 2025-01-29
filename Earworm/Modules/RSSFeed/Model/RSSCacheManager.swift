//
//  RSSCacheManager.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 28/01/25.
//

import Foundation

struct RSSCacheManager {
    private static let cacheKey = "cachedRSSFeed"

    static func save(feed: RSSFeed) {
        if let encoded = try? JSONEncoder().encode(feed) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }

    static func load() -> RSSFeed? {
        guard let savedData = UserDefaults.standard.data(forKey: cacheKey),
              let decodedFeed = try? JSONDecoder().decode(RSSFeed.self, from: savedData)
        else { return nil }
        return decodedFeed
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
}
