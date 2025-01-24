//
//  CustomButton.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation
import UIKit

class CustomButton: UIButton {

    init(title: String, backgroundColor: UIColor = .systemBlue, cornerRadius: CGFloat = 8.0, textColor: UIColor = .white) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.setTitleColor(textColor, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
