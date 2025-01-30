//
//  DownloadEpisodeCellDelegate.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation

protocol DownloadEpisodeCellDelegate: AnyObject {
    func didTapDelete(for episode: Episode)
}
