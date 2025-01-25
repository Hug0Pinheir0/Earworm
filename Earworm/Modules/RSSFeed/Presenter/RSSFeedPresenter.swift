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
    
    // Inicializador
    init(view: RSSFeedViewProtocol) {
        self.view = view
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
        
        // Se a URL for válida
        print("URL válida: \(urlString)")
    }
    
    private func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}

