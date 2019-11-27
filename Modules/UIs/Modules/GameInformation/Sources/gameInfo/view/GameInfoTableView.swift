//
//  GameInfoTableView.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents
import Design

class GameInfoTableView: ApTableView
{
    private var gameInfoViewModel: SkeletonViewModel<GameInfoViewModel> = .loading
    private var achievementsSummaryViewModel: SkeletonViewModel<AchievementsSummaryViewModel?> = .loading

    init() {
        super.init(frame: .zero, style: .plain)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateGameInfo(_ gameInfo: SkeletonViewModel<GameInfoViewModel>) {
        gameInfoViewModel = gameInfo
        reloadData()
    }

    func updateAchiementSummary(_ achievementsSummary: SkeletonViewModel<AchievementsSummaryViewModel?>) {
        achievementsSummaryViewModel = achievementsSummary
        reloadData()
    }

    private func commonInit() {
        register(GameInfoCell.self, forCellReuseIdentifier: GameInfoCell.identifier)
        self.dataSource = self
        self.delegate = self

        self.tableFooterView = UIView(frame: .zero)
    }
}

extension GameInfoTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeight(for: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeight(for: indexPath)
    }

    private func calculateHeight(for indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section {
            return GameInfoCell.preferredHeight
        }
        return GameInfoCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if 0 == indexPath.section {
        return tableView.dequeueReusableCell(withIdentifier: GameInfoCell.identifier, for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let gameInfoCell = cell as? GameInfoCell {
            gameInfoCell.configure(gameInfoViewModel)
            addViewForStylizing(gameInfoCell)
        }
    }
}
