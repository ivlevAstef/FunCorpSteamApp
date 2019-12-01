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

final class GameInfoScreenView: ApViewController, CustomGameInfoViewContract, GameInfoScreenViewContract
{
    let needUpdateNotifier = Notifier<Void>()

    private let tableView: GameInfoTableView

    init(cellConfigurator: CustomTableCellConfiguratorComposite) {
        tableView = GameInfoTableView(cellConfigurator: cellConfigurator)
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

    func setTitles(gameInfo: String, achievementsSummary: String) {
        tableView.setTitles(gameInfo: gameInfo, achievementsSummary: achievementsSummary)
    }

    func beginLoadingGameInfoAndAchievements() {
        tableView.updateGameInfo(.loading)
        tableView.updateAchievementSummary(.loading)
    }

    // MARK: - GameInfo
    func failedLoadingGameInfo() {
        tableView.updateGameInfo(.failed)
    }

    func showGameInfo(_ gameInfo: GameInfoViewModel) {
        tableView.updateGameInfo(.done(gameInfo))
    }

    // MARK: - Achievements

    func failedLoadingAchievementsSummary() {
        tableView.updateAchievementSummary(.failed)
    }

    func showAchievementsSummary(_ achievementsSummary: AchievementsSummaryViewModel?) {
        tableView.updateAchievementSummary(.done(achievementsSummary))
    }

    func showError(_ text: String) {
        ErrorAlert.show(text, on: self)
    }

    // MARK: - Custom

    func addCustomSection(title: String?, style: CustomViewModelStyle, order: UInt) {
        tableView.addCustomSection(title: title, style: style, order: order)
    }

    func removeCustomSection(order: UInt) {
        tableView.removeCustomSection(order: order)
    }

    func beginCustomLoading(style: CustomViewModelStyle, order: UInt) {
        tableView.updateCustom(.loading, order: order)
    }

    func failedCustomLoading(style: CustomViewModelStyle, order: UInt) {
        tableView.updateCustom(.failed, order: order)
    }

    func showCustom(_ viewModel: CustomViewModel, order: UInt) {
        tableView.updateCustom(.done(viewModel), order: order)
    }

    // MARK: - other

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
