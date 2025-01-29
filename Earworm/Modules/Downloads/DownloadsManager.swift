//
//  DownloadsManager.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import Foundation

class DownloadsManager {
    
    static let shared = DownloadsManager()
    
    private let userDefaultsKey = "downloadedEpisodes"
    
    private init() {}

    func saveEpisode(_ episode: Episode) {
        var episodes = getDownloadedEpisodes()
        episodes.append(episode)
        saveToUserDefaults(episodes)
    }

    func getDownloadedEpisodes() -> [Episode] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let episodes = try? JSONDecoder().decode([Episode].self, from: data) else {
            return []
        }
        return episodes
    }
    
    func removeEpisode(_ episode: Episode) {
        var episodes = getDownloadedEpisodes()
        episodes.removeAll { $0.audioURL == episode.audioURL } 
        saveToUserDefaults(episodes)
    }

    private func saveToUserDefaults(_ episodes: [Episode]) {
        if let data = try? JSONEncoder().encode(episodes) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
