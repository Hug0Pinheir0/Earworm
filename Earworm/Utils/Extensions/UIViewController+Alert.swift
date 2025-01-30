//
//  UIViewController+Alert.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation
import UIKit

extension UIViewController {
    /// Exibe um alerta simples
    /// - Parameters:
    ///   - title: O título do alerta (padrão: "Atenção").
    ///   - message: A mensagem do alerta.
    ///   - buttonTitle: O texto do botão de ação (padrão: "OK").
    func showAlert(title: String = "Atenção", message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
