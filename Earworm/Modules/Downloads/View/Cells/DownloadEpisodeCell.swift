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

    private let titleLabel: CustomLabel = {
        let label = CustomLabel(
            text: "",
            fontSize: 16,
            textColor: .black,
            alignment: .center
        )
        return label
    }()

    private lazy var deleteButton: CustomButton = {
        let button = CustomButton(
            title: "",
            backgroundColor: .clear
        )
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
        stackView.distribution = .fill
        return stackView
    }()

    private var episode: Episode?

     func configure(with episode: Episode) {
        self.episode = episode
        titleLabel.text = episode.title
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(deleteButton)

        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        deleteButton.setContentHuggingPriority(.required, for: .horizontal)
        deleteButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    @objc private func deleteTapped() {
        guard let episode = episode else { return }
        delegate?.didTapDelete(for: episode)
    }
}
