//
//  SessionsScreenView.swift
//  Sessions
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import UIKit
import Common
import UIComponents

final class SessionsScreenView: ApViewController, SessionsScreenViewContract
{
    let needUpdateNotifier = Notifier<Void>()

    private let tableView = SessionsTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = loc["SteamSessions.Title"]

        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        needUpdateNotifier.notify(())
    }

    func beginLoading() {
        tableView.updateSessions(Array(repeating: .loading, count: 8))
    }

    func failedLoadingSessions() {
        tableView.updateSessions(Array(repeating: .failed, count: 8))
    }

    func showSessions(_ sessions: [SessionViewModel]) {
        tableView.updateSessions(sessions.map { .done($0) })
    }

    // MARK: - other

    func showError(_ text: String) {
        ErrorAlert.show(text, on: self)
    }

    private func configureViews() {
        view.addSubview(tableView)

        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear

        addViewForStylizing(tableView)

        tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
}
