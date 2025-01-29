//
//  AudioPlayerManager.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    
    static let shared = AudioPlayerManager()
    
    private var player: AVPlayer?
    
    private init() {}

    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
        print("🎵 Reproduzindo: \(url)")
    }
    
    func pause() {
        player?.pause()
    }

    func stop() {
        player?.pause()
        player = nil
    }
}
