//
//  RSSCacheManager.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 28/01/25.
//

import Foundation

struct RSSCacheManager {
    
    static func save(feed: RSSFeed, for url: String) {
        let cacheKey = "cachedRSSFeed_\(url)"
        if let encoded = try? JSONEncoder().encode(feed) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }

    static func load(for url: String) -> RSSFeed? {
        let cacheKey = "cachedRSSFeed_\(url)"
        guard let savedData = UserDefaults.standard.data(forKey: cacheKey),
              let decodedFeed = try? JSONDecoder().decode(RSSFeed.self, from: savedData)
        else { return nil }
        return decodedFeed
    }

    static func clear(for url: String) {
        let cacheKey = "cachedRSSFeed_\(url)"
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
    
    static func clearAll() {
        UserDefaults.standard.dictionaryRepresentation().keys
            .filter { $0.starts(with: "cachedRSSFeed_") }
            .forEach { UserDefaults.standard.removeObject(forKey: $0) }
    }
}
