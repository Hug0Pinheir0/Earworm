//
//  RssFeed.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation

struct RSSFeed {
    let title: String
    let description: String
    let imageURL: String
    let authors: String
    let category: String // Atualizado para refletir o dado real da API
    let episodes: [Episode]
}

struct Episode {
    let title: String
    let audioURL: URL
    let duration: String
}


