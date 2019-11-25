//
//  ProfileScreenView.swift
//  Profile
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import AppUIComponents
import UIComponents
import Common
import Design
import SnapKit

final class ProfileScreenView: ApViewController, ProfileScreenViewContract
{
    let needUpdateNotifier = Notifier<Void>()

    private let tableView = ProfileTableView()

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = loc["SteamProfile.Title"]

        configureViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        needUpdateNotifier.notify(())
    }

    // MARK: - profile

    func beginLoadingProfile() {
        tableView.updateProfile(.loading)
    }

    func endLoadingProfile(_ success: Bool) {
        if !success {
            tableView.updateProfile(.failed)
        }
    }

    func showProfile(_ profile: ProfileViewModel) {
        tableView.updateProfile(.done(profile))
    }

    func showError(_ text: String) {
        ErrorAlert.show(text, on: self)
    }

    // MARK: - games

    func beginLoadingGames() {
        tableView.updateGames(Array(repeating: .loading, count: 6))
    }

    func endLoadingGames(_ success: Bool) {
        if !success {
            tableView.updateGames(Array(repeating: .failed, count: 6))
        }
    }

    func showGamesInfo(_ games: [ProfileGameInfoViewModel]) {
        tableView.updateGames(games.map { .done($0) })
    }

    func setGamesSectionText(_ text: String) {
        tableView.setGamesSectionTitle(text)
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
