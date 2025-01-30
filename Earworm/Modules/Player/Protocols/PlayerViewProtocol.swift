//
//  PlayerViewProtocol.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 30/01/25.
//

import Foundation

protocol PlayerViewProtocol: AnyObject {
    func updateDownloadButton(isDownloaded: Bool)
    func updatePlayPauseButton(isPlaying: Bool)
    func showDownloadCompletion()
    func showDownloadError(_ message: String)
    func updateUI(with episode: Episode)
    func updateProgress(_ progress: Float)
}
