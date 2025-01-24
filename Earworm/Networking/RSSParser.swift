//
//  RSSParser.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    private var currentElement = ""
    private var feedTitle = ""
    private var feedDescription = ""
    private var episodes: [Episode] = []
    private var currentEpisodeTitle = ""
    private var currentEpisodeAudioURL: URL?
    
    func parse(xml: String) -> RSSFeed? {
        guard let data = xml.data(using: .utf8) else { return nil }
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return RSSFeed(title: feedTitle, description: feedDescription, episodes: episodes)
    }
    
    // MARK: - XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        currentElement = elementName
        if elementName == "enclosure", let urlString = attributeDict["url"], let url = URL(string: urlString) {
            currentEpisodeAudioURL = url
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            if feedTitle.isEmpty {
                feedTitle = string
            } else {
                currentEpisodeTitle += string
            }
        case "description":
            feedDescription += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let url = currentEpisodeAudioURL {
                episodes.append(Episode(title: currentEpisodeTitle, audioURL: url))
            }
            currentEpisodeTitle = ""
            currentEpisodeAudioURL = nil
        }
    }
}
