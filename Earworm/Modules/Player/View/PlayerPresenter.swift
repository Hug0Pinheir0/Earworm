//
//  PlayerPresenter.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 30/01/25.
//

import Foundation

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
        
        DownloadsManager.shared.saveDownloadedEpisode(episode)
        view?.showDownloadCompletion()
    }

    func togglePlayPause() {
        print("🎵 Toggle Play/Pause - Adicionar lógica do player aqui")
    }

    func previousEpisode() {
        print("⏮ Retornar ao episódio anterior")
    }

    func nextEpisode() {
        print("⏭ Avançar para o próximo episódio")
    }
}
