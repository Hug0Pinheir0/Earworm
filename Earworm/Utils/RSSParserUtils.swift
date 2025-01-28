//
//  RSSParserUtils.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 27/01/25.
//

import Foundation
import UIKit

struct RSSParserUtils {
    
   static func cleanDescription(_ description: String) -> String {
         let patternsToRemove = [
            "Visit megaphone.fm/adchoices",
            "Learn more about your ad choices."
        ]
        var cleanedDescription = description
        for pattern in patternsToRemove {
            cleanedDescription = cleanedDescription.replacingOccurrences(of: pattern, with: "")
        }
        if cleanedDescription.count > 300 {
            cleanedDescription = String(cleanedDescription.prefix(300)) + "..."
        }
        return cleanedDescription.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func convertHTMLToPlainText(html: String) -> String? {
        guard let data = html.data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
            return attributedString.string
        } catch {
            print("Erro ao converter HTML para texto: \(error)")
            return nil
        }
    }

    static func formatDuration(_ duration: String) -> String {
        guard let totalSeconds = Int(duration) else { return "00:00:00" }
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

