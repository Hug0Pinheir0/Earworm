//
//  CustomCardView.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 30/01/25.
//

import Foundation
import UIKit
import SnapKit

class CustomCardView: UIView {
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
    }
}
