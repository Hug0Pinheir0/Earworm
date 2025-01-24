//
//  CustomImageView.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {

    init(cornerRadius: CGFloat = 8.0, contentMode: UIView.ContentMode = .scaleAspectFill) {
        super.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = contentMode
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
