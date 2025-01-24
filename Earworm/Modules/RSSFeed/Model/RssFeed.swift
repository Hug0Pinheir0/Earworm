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
    let episodes: [Episode]
}

struct Episode {
    let title: String
    let audioURL: URL
}

