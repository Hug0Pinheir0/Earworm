//
//  BaseTableViewController.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 29/01/25.
//

import Foundation
import UIKit
import SnapKit

class BaseTableViewController<T, Cell: BaseTableViewCell>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var items: [T] = []
    
    private let contentContainer = UIView()
    let tableView = UITableView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(contentContainer)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
    }

    private func setupConstraints() {
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        configureTableConstraints()
    }

    func configureTableConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentContainer.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Content View Management
    func addContentView(_ view: UIView) {
        contentContainer.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        configureCell(cell, with: items[indexPath.row])
        return cell
    }
    
    open func configureCell(_ cell: Cell, with item: T) { }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        didSelectItem(selectedItem, at: indexPath)
    }
    
    open func didSelectItem(_ item: T, at indexPath: IndexPath) { }
}
