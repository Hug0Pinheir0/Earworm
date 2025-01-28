//
//  URLValidator.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 28/01/25.
//

import Foundation

struct URLValidator {
    static func isValid(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}
