//  RSSParser.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.

import Foundation
import FeedKit

class RSSParser {
    
    func parse(xmlString: String, completion: @escaping (RSSFeed?) -> Void) {
        guard let data = xmlString.data(using: .utf8) else {
            completion(nil)
            return
        }

        let parser = FeedParser(data: data)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case .success(let feed):
                switch feed {
                case .rss(let rssFeed):
                    print("✅ Parsing RSS Feed com sucesso!")
                    let convertedFeed = self.convertToRSSFeed(rssFeed)
                    completion(convertedFeed)
                default:
                    print("⚠️ Tipo de feed não suportado")
                    completion(nil)
                }
            case .failure(let error):
                print("❌ Erro ao parsear XML: \(error.localizedDescription)")  
                completion(nil)
            }
        }
    }

    private func convertToRSSFeed(_ feed: FeedKit.RSSFeed) -> RSSFeed {
        let episodes = feed.items?.compactMap { item -> Episode? in
            guard let title = item.title,
                  let description = item.description,
                  let audioURL = item.enclosure?.attributes?.url,
                  let duration = item.iTunes?.iTunesDuration else { return nil }
            
            return Episode(title: title, description: description, audioURL: URL(string: audioURL) ?? URL(string: "https://placeholder.com")!, duration: "\(duration)")
        } ?? []

        return RSSFeed(
            title: feed.title ?? "Sem título",
            description: feed.description ?? "Sem descrição",
            imageURL: feed.image?.url ?? "",
            authors: feed.iTunes?.iTunesAuthor ?? "Desconhecido",
            category: feed.categories?.first?.value ?? "Sem categoria",
            episodes: episodes
        )
    }
}
