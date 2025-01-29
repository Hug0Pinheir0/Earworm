//
//  EpisodePlaybackDelegate.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation

protocol EpisodePlaybackDelegate: AnyObject {
    func didTapPlayPause(for episode: Episode, in cell: EpisodeTableViewCell)
}
