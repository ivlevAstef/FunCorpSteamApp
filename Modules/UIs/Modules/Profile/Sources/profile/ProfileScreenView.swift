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

    private let steamNavBar: SteamNavBar

    private let gamesView = ProfileGamesTableView()

    init(steamNavBar: SteamNavBar) {
        self.steamNavBar = steamNavBar
        super.init(navStatusBar: steamNavBar.view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()

        self.steamNavBar.parentVC = self
        self.steamNavBar.view.bind(to: gamesView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        needUpdateNotifier.notify(())
    }

    func showError(_ text: String) {
        ErrorAlert.show(text, on: self)
    }

    // MARK: - games

    func beginLoadingGames() {
    }

    func endLoadingGames(_ success: Bool) {
    }

    func setGamesSectionText(_ text: String) {
        gamesView.setSectionTitle(text)
    }

    func showGamesInfo(_ games: [ProfileGameInfoViewModel]) {
        gamesView.update(games)
    }

    private func configureViews() {
        view.addSubview(gamesView)

        gamesView.clipsToBounds = true
        gamesView.backgroundColor = .clear

        addViewForStylizing(gamesView)

        gamesView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }

}
