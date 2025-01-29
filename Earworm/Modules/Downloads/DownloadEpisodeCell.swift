//
//  DownloadEpisodeCell.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit

class DownloadEpisodeCell: BaseTableViewCell {

    weak var delegate: DownloadEpisodeCellDelegate?

    private let titleLabel = CustomLabel(text: "", fontSize: 16, textColor: .black, alignment: .left)
    
    private lazy var deleteButton: CustomButton = {
        let button = CustomButton(title: "", backgroundColor: .clear)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()

    private var episode: Episode?

     func configure(with episode: Episode) {
        self.episode = episode
        titleLabel.text = episode.title
    }


    @objc private func deleteTapped() {
        guard let episode = episode else { return }
        delegate?.didTapDelete(for: episode)
    }
}
