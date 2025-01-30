//
//  AudioPlayerManager.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioPlayerManager {
    
    static let shared = AudioPlayerManager()
    
    private var player: AVPlayer?
    private var isCurrentlyPlaying = false
    private var currentEpisode: Episode?
    private var episodeList: [Episode] = []
    private var currentIndex: Int = 0

    var onProgressUpdate: ((Float) -> Void)?
    var onEpisodeChange: ((Episode) -> Void)?

    private init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Erro ao configurar o AVAudioSession: \(error.localizedDescription)")
        }
    }

    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
        isCurrentlyPlaying = true
        startProgressTracking()
    }
    
    func playPause() {
        guard let player = player else { return }
        if isCurrentlyPlaying {
            pause()
        } else {
            player.play()
        }
        isCurrentlyPlaying.toggle()
    }
    
    func getPlayer() -> AVPlayer? {
        return player
    }
    
    func pause() {
        player?.pause()
        isCurrentlyPlaying = false
    }

    func stop() {
        player?.pause()
        player = nil
        isCurrentlyPlaying = false
    }

    func isPlaying() -> Bool {
        return isCurrentlyPlaying
    }

    func loadEpisodes(_ episodes: [Episode], startIndex: Int = 0) {
        self.episodeList = episodes
        self.currentIndex = startIndex
        playCurrentEpisode()
    }

    private func playCurrentEpisode() {
        guard !episodeList.isEmpty, currentIndex >= 0, currentIndex < episodeList.count else { return }
        let episode = episodeList[currentIndex]
        currentEpisode = episode
        play(url: episode.audioURL)
        onEpisodeChange?(episode)
    }

    func playNext() {
        guard currentIndex < episodeList.count - 1 else { return }
        currentIndex += 1
        playCurrentEpisode()
    }

    func playPrevious() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        playCurrentEpisode()
    }

    func getCurrentEpisode() -> Episode? {
        return currentEpisode
    }

    private func startProgressTracking() {
        guard let player = player else { return }
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let duration = player.currentItem?.duration.seconds ?? 1
            let currentTime = time.seconds
            let progress = Float(currentTime / duration)
            self?.onProgressUpdate?(progress)
        }
    }
}
