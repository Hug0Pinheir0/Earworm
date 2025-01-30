//
//  DownloadsManager.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import Alamofire

class DownloadsManager {
    
    static let shared = DownloadsManager()
    private let userDefaultsKey = "downloadedEpisodes"
    
    private init() {}

    
    func downloadEpisode(_ episode: Episode, completion: @escaping (Bool) -> Void) {
        if isEpisodeDownloaded(episode) {
            completion(false) // Já baixado, não baixa de novo
            return
        }

        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = self.getEpisodeFileURL(for: episode)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(episode.audioURL, to: destination).response { response in
            if response.error == nil {
                self.saveDownloadedEpisode(episode)
                NotificationCenter.default.post(name: .didDownloadEpisode, object: episode)
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func isEpisodeDownloaded(_ episode: Episode) -> Bool {
        return getDownloadedEpisodes().contains(where: { $0.audioURL == episode.audioURL })
    }

    func getDownloadedEpisodes() -> [Episode] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let episodes = try? JSONDecoder().decode([Episode].self, from: data) else {
            return []
        }
        return episodes
    }

    func saveDownloadedEpisode(_ episode: Episode) {
        var episodes = getDownloadedEpisodes()
        
        if !episodes.contains(where: { $0.audioURL == episode.audioURL }) {
            episodes.append(episode)
            saveToUserDefaults(episodes)
        }
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
    
    func getEpisodeFileURL(for episode: Episode) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(episode.title).mp3")
    }
}

extension NSNotification.Name {
    static let didDownloadEpisode = NSNotification.Name("didDownloadEpisode")
}

