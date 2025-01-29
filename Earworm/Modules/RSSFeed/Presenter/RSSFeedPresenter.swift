//
//  RSSFeedPresenter.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation
import UIKit

class RSSFeedPresenter {
    
    // MARK: - Properties
    private weak var view: RSSFeedViewProtocol?
    private let networkService: NetworkService
    
    // Inicializador
    init(view: RSSFeedViewProtocol, networkService: NetworkService = .shared) {
        self.view = view
        self.networkService = networkService
    }
    
    // MARK: - Lógica de Negócio
    
    func handleSubmitButtonTapped(with urlString: String?) {
        guard let urlString = urlString, !urlString.isEmpty else {
            view?.showAlert(message: "Por favor, insira uma URL válida.")
            return
        }
        
        if let cachedFeed = RSSCacheManager.load(for: urlString) {
            DispatchQueue.main.async {
                self.view?.updateUI(with: cachedFeed) 
            }
            return
        }
        
        guard URLValidator.isValid(urlString) else {
            view?.showAlert(message: "A URL inserida é inválida.")
            return
        }
        
        networkService.fetchRSS(from: urlString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    RSSCacheManager.save(feed: feed, for: urlString)
                    self?.view?.updateUI(with: feed)
                case .failure(let error):
                    self?.view?.showAlert(message: "Erro ao buscar o feed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func navigateToDetails(with feed: RSSFeed) {
        guard let viewController = view as? UIViewController else { return }
        NavigationManager.shared.showPodcastDetails(from: viewController, with: feed)
    }
}

