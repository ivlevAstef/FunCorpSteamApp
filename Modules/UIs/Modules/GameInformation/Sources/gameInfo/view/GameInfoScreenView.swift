//
//  GameInfoScreenView.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents

final class GameInfoScreenView: ApViewController, GameInfoScreenViewContract
{
    let needUpdateNotifier = Notifier<Void>()

    private let tableView = GameInfoTableView()

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = loc["SteamGame.Title"]

        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        needUpdateNotifier.notify(())
    }

    func beginLoading() {
        tableView.updateGameInfo(.loading)
    }

    // MARK: - GameInfo
    func endLoadingGameInfo(_ success: Bool) {
        if !success {
            tableView.updateGameInfo(.failed)
        }
    }

    func showGameInfo(_ gameInfo: GameInfoViewModel) {
        tableView.updateGameInfo(.done(gameInfo))
    }

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
