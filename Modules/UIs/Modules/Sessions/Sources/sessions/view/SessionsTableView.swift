//
//  SessionsTableView.swift
//  Sessions
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import SnapKit
import Design
import UIComponents

final class SessionsTableView: ApTableView
{
    private var sessionsViewModels: [SkeletonViewModel<SessionViewModel>] = []

    init() {
        super.init(frame: .zero, style: .grouped)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func updateSessions(_ viewModels: [SkeletonViewModel<SessionViewModel>]) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        sessionsViewModels = viewModels
        reloadData()
    }

    private func commonInit() {
        register(SessionCell.self, forCellReuseIdentifier: SessionCell.identifier)
        self.dataSource = self
        self.delegate = self

        self.tableFooterView = UIView(frame: .zero)
    }
}

extension SessionsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionsViewModels.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeight(for: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeight(for: indexPath)
    }

    private func calculateHeight(for indexPath: IndexPath) -> CGFloat {
        return SessionCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SessionCell.identifier, for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let sessionCell = cell as? SessionCell {
            sessionCell.configure(sessionsViewModels[indexPath.row])
            addViewForStylizing(sessionCell)
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if case .done = sessionsViewModels[indexPath.row] {
            return indexPath
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .done(viewModel) = sessionsViewModels[indexPath.row] {
            DispatchQueue.main.async {
                viewModel.tapNotifier.notify(())
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
