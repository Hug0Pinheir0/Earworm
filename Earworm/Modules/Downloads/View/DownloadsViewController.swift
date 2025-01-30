//
//  DownloadsViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit
import SnapKit

class DownloadsViewController: BaseTableViewController<Episode, DownloadEpisodeCell> {

    // MARK: - UI Elements
    private let titleLabel: CustomLabel = {
        return CustomLabel(text: "Downloads", fontSize: 24, textColor: .black, alignment: .center)
    }()

    private let emptyStateLabel: CustomLabel = {
        return CustomLabel(text: "Nenhum episódio baixado", fontSize: 16, textColor: .gray, alignment: .center)
    }()

    private let contentView = UIView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDownloads()
    }

    private func setupUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100) // Define um tamanho fixo para o header
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }

        view.addSubview(emptyStateLabel)
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        emptyStateLabel.isHidden = true
    }
    
    override func configureTableConstraints() {
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide) // Ocupa toda a tela
            make.leading.trailing.bottom.equalToSuperview()
        }
    }


    private func loadDownloads() {
        let episodes = DownloadsManager.shared.getDownloadedEpisodes()
        self.items = episodes
        tableView.reloadData()
        updateUIState()
    }

    private func updateUIState() {
        let hasDownloads = !items.isEmpty
        tableView.isHidden = !hasDownloads
        emptyStateLabel.isHidden = hasDownloads
    }

    override func configureCell(_ cell: DownloadEpisodeCell, with item: Episode) {
        cell.configure(with: item)
        cell.delegate = self
    }

    override func didSelectItem(_ item: Episode, at indexPath: IndexPath) {
        NavigationManager.shared.showPlayer(from: self, with: item, episodesList: items, startIndex: indexPath.row)
    }
}

// MARK: - DownloadEpisodeCellDelegate
extension DownloadsViewController: DownloadEpisodeCellDelegate {
    func didTapDelete(for episode: Episode) {
        DownloadsManager.shared.removeEpisode(episode)
        loadDownloads()
    }
}
