//
//  DownloadsViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit
import SnapKit

class DownloadsViewController: UIViewController {
    
    // MARK: - Properties
    private var downloadedEpisodes: [Episode] = []

    // MARK: - UI Elements
    private let titleLabel: CustomLabel = {
        return CustomLabel(text: "Downloads", fontSize: 24, textColor: .black, alignment: .center)
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DownloadEpisodeCell.self, forCellReuseIdentifier: DownloadEpisodeCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let emptyStateLabel: CustomLabel = {
        return CustomLabel(text: "Nenhum episódio baixado", fontSize: 16, textColor: .gray, alignment: .center)
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        loadDownloads()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func loadDownloads() {
        downloadedEpisodes = DownloadsManager.shared.getDownloadedEpisodes()
        tableView.reloadData()
        emptyStateLabel.isHidden = !downloadedEpisodes.isEmpty
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DownloadEpisodeCell.identifier, for: indexPath) as? DownloadEpisodeCell else {
            return UITableViewCell()
        }
        let episode = downloadedEpisodes[indexPath.row]
        cell.configure(with: episode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !downloadedEpisodes.isEmpty else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedEpisode = downloadedEpisodes[indexPath.row]
        NavigationManager.shared.showPlayer(from: self, with: selectedEpisode, episodesList: downloadedEpisodes, startIndex: indexPath.row)
    }
}



