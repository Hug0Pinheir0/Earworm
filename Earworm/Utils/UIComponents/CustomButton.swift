//
//  CustomButton.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import UIKit

class CustomButton: UIButton {

    private var actionHandler: (() -> Void)?

    init(title: String, backgroundColor: UIColor = .systemBlue, cornerRadius: CGFloat = 8.0, textColor: UIColor = .white, action: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.setTitleColor(textColor, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false

        if let action = action {
            self.actionHandler = action
            self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }

    @objc private func buttonTapped() {
        actionHandler?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
