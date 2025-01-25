//
//  RSSFeedPresenter.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation

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
        
        guard isValidURL(urlString) else {
            view?.showAlert(message: "A URL inserida é inválida.")
            return
        }
        
        
        networkService.fetchRSS(from: urlString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feed):
                    self?.view?.updateUI(with: feed) // Atualizar a UI com os dados do feed
                case .failure(let error):
                    self?.view?.showAlert(message: "Erro ao buscar o feed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}

