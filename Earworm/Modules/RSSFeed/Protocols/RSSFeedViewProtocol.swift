//
//  RSSFeedViewProtocol.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation

protocol RSSFeedViewProtocol: AnyObject {
    func showAlert(message: String)
    func updateUI(with feed: RSSFeed)
}
