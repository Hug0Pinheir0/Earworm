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
    private var feedCategory = ""
    private var episodes: [Episode] = []
    private var currentEpisodeTitle = ""
    private var currentEpisodeDescription = ""
    private var currentEpisodeAudioURL: URL?
    private var currentEpisodeDuration = ""

    func parse(xml: String) -> RSSFeed? {
        guard let data = xml.data(using: .utf8) else { return nil }
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return RSSFeed(
            title: feedTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            description: RSSParserUtils.cleanDescription(feedDescription),
            imageURL: feedImageURL,
            authors: feedAuthors.trimmingCharacters(in: .whitespacesAndNewlines),
            category: feedCategory.trimmingCharacters(in: .whitespacesAndNewlines),
            episodes: episodes.map { episode in
                Episode(
                    title: episode.title,
                    description: RSSParserUtils.cleanDescription(episode.description),
                    audioURL: episode.audioURL,
                    duration: episode.duration
                )
            }
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
            if episodes.isEmpty {
                feedDescription += " " + trimmedString
            } else {
                currentEpisodeDescription += " " + trimmedString
            }
        case "itunes:author":
            feedAuthors = trimmedString
        case "itunes:category":
            feedCategory = trimmedString
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
                        description: currentEpisodeDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                        audioURL: url,
                        duration: currentEpisodeDuration.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                )
            }
            currentEpisodeTitle = ""
            currentEpisodeDescription = ""
            currentEpisodeAudioURL = nil
            currentEpisodeDuration = ""
        }
    }
}
