//
//  TimeStringExtension.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 30/01/25.
//

import Foundation

extension String {
    func toTimeString() -> String {
        guard let seconds = Double(self) else { return "--:--" }
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
