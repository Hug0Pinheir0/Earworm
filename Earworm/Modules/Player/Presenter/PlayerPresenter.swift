//
//  PlayerPresenter.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 30/01/25.
//

import Foundation
import AVFoundation
import MediaPlayer


class PlayerPresenter {
    
    weak var view: PlayerViewProtocol?
    private var episode: Episode
    private var episodeList: [Episode]
    private var currentIndex: Int
    
    init(view: PlayerViewProtocol?, episode: Episode, episodeList: [Episode], startIndex: Int) {
        self.view = view
        self.episode = episode
        self.episodeList = episodeList
        self.currentIndex = startIndex
        observePlaybackProgress()
        setupBackgroundPlayback()
    }

    func checkDownloadStatus() {
        let isDownloaded = DownloadsManager.shared.isEpisodeDownloaded(episode)
        view?.updateDownloadButton(isDownloaded: isDownloaded)
    }

    func downloadEpisode() {
        if DownloadsManager.shared.isEpisodeDownloaded(episode) {
            view?.showDownloadError("Episódio já baixado!")
            return
        }
        
        DownloadsManager.shared.downloadEpisode(episode) { success in
            DispatchQueue.main.async {
                if success {
                    self.view?.showDownloadCompletion()
                } else {
                    self.view?.showDownloadError("Erro ao baixar o episódio.")
                }
            }
        }
    }
    
    func startPlayback() {
        AudioPlayerManager.shared.play(url: episode.audioURL)
        view?.updateUI(with: episode)
    }

    func togglePlayPause() {
        if AudioPlayerManager.shared.isPlaying() {
            AudioPlayerManager.shared.pause()
        } else {
            AudioPlayerManager.shared.play(url: episode.audioURL)
        }
        view?.updatePlayPauseButton(isPlaying: AudioPlayerManager.shared.isPlaying())
    }

    func previousEpisode() {
        guard currentIndex > 0 else { return }
        AudioPlayerManager.shared.stop()
        currentIndex -= 1
        episode = episodeList[currentIndex]
        AudioPlayerManager.shared.play(url: episode.audioURL)
        view?.updateUI(with: episode)
    }

    func nextEpisode() {
        guard currentIndex < episodeList.count - 1 else { return }
        AudioPlayerManager.shared.stop()
        currentIndex += 1
        episode = episodeList[currentIndex]
        AudioPlayerManager.shared.play(url: episode.audioURL)
        view?.updateUI(with: episode)
    }

    func observePlaybackProgress() {
        AudioPlayerManager.shared.onProgressUpdate = { [weak self] progress in
            self?.view?.updateProgress(progress)
        }
    }

    private func setupBackgroundPlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Erro ao configurar reprodução em background: \(error.localizedDescription)")
        }
    }
}
