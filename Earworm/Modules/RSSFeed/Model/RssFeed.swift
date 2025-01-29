//
//  RssFeed.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation

struct RSSFeed: Codable {
    let title: String
    let description: String
    let imageURL: String
    let authors: String
    let category: String
    let episodes: [Episode]
}

struct Episode: Codable {
    let title: String
    let description: String
    let audioURL: URL
    let duration: String
}

