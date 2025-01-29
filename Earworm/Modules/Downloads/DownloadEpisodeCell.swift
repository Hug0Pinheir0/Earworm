//
//  DownloadEpisodeCell.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit

class DownloadEpisodeCell: UITableViewCell {
    
    static let identifier = "DownloadEpisodeCell"

    private let titleLabel = CustomLabel(text: "", fontSize: 16, textColor: .black, alignment: .left)
    
    private let deleteButton: CustomButton = {
        let button = CustomButton(
            title: "",
            backgroundColor: .clear,
            action: nil
        )
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(deleteButton)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with episode: Episode) {
        self.episode = episode
        titleLabel.text = episode.title
    }

    @objc private func deleteTapped() {
        guard let episode = episode else { return }
        DownloadsManager.shared.removeEpisode(episode)
    }
}
