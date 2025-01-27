//  RSSParser.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    private var currentElement = ""
    private var feedTitle = ""
    private var feedDescription = ""
    private var feedImageURL = ""
    private var feedAuthors = ""
    private var feedCategory = "" // Renamed to reflect the XML tag
    private var episodes: [Episode] = []
    private var currentEpisodeTitle = ""
    private var currentEpisodeAudioURL: URL?
    private var currentEpisodeDuration = ""

    func parse(xml: String) -> RSSFeed? {
        guard let data = xml.data(using: .utf8) else { return nil }
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return RSSFeed(
            title: feedTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            description: cleanDescription(feedDescription),
            imageURL: feedImageURL,
            authors: feedAuthors.trimmingCharacters(in: .whitespacesAndNewlines),
            category: feedCategory.trimmingCharacters(in: .whitespacesAndNewlines), // Uses category as genre
            episodes: episodes
        )
    }

    // MARK: - XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        currentElement = elementName

        // Captura a URL da imagem do feed
        if elementName == "itunes:image", let url = attributeDict["href"] {
            feedImageURL = url
        }

        // Captura informações do episódio atual (se estiver dentro de um item)
        if elementName == "enclosure", let urlString = attributeDict["url"], let url = URL(string: urlString) {
            currentEpisodeAudioURL = url
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedString.isEmpty else { return }

        switch currentElement {
        case "title":
            if feedTitle.isEmpty {
                feedTitle = trimmedString
            } else {
                currentEpisodeTitle += trimmedString
            }
        case "description":
            feedDescription += trimmedString
        case "itunes:author":
            feedAuthors = trimmedString
        case "itunes:category":
            feedCategory = trimmedString // Changed to use "category"
        case "itunes:duration":
            currentEpisodeDuration = trimmedString
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let url = currentEpisodeAudioURL {
                episodes.append(
                    Episode(
                        title: currentEpisodeTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                        audioURL: url,
                        duration: currentEpisodeDuration.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                )
            }
            currentEpisodeTitle = ""
            currentEpisodeAudioURL = nil
            currentEpisodeDuration = ""
        }
    }

    // MARK: - Helper Methods
    private func cleanDescription(_ description: String) -> String {
        // Remove links e texto desnecessário
        let patternsToRemove = [
            "Visit megaphone.fm/adchoices",
            "Learn more about your ad choices."
        ]
        var cleanedDescription = description
        for pattern in patternsToRemove {
            cleanedDescription = cleanedDescription.replacingOccurrences(of: pattern, with: "")
        }
        // Trunca o texto se for muito longo
        if cleanedDescription.count > 300 {
            cleanedDescription = String(cleanedDescription.prefix(300)) + "..."
        }
        return cleanedDescription.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
