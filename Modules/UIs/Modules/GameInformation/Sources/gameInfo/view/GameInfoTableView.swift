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
    typealias Section<T> = ApTableView.TableSection<SkeletonViewModel<T>>

    // Для массива
    private enum TypedSection {
        case gameInfo(Section<GameInfoViewModel>)
        case achievementsSummary(Section<AchievementsSummaryViewModel?>)
    }
    private var sections: [TypedSection] = []

    private var gameInfoSection = Section<GameInfoViewModel>(content: .loading)
    private var achievementsSummarySection = Section<AchievementsSummaryViewModel?>(content: .loading)

    init() {
        super.init(frame: .zero, style: .grouped)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitles(gameInfo: String, achievementsSummary: String) {
        gameInfoSection.title = gameInfo
        achievementsSummarySection.title = achievementsSummary
    }

    func updateGameInfo(_ gameInfo: SkeletonViewModel<GameInfoViewModel>) {
        gameInfoSection.content = gameInfo
        updateSections()
        reloadData()
    }

    func updateAchiementSummary(_ achievementsSummary: SkeletonViewModel<AchievementsSummaryViewModel?>) {
        achievementsSummarySection.content = achievementsSummary
        updateSections()
        reloadData()
    }

    private func updateSections() {
        func hasAchievementsSummaryCell() -> Bool {
            if case .done(let viewModel) = achievementsSummarySection.content {
                return viewModel != nil
            }
            return true
        }

        var newSections: [TypedSection] = []
        newSections.append(.gameInfo(gameInfoSection))
        if hasAchievementsSummaryCell() {
            newSections.append(.achievementsSummary(achievementsSummarySection))
        }
        sections = newSections
    }

    private func commonInit() {
        register(GameInfoCell.self, forCellReuseIdentifier: GameInfoCell.identifier)
        register(AchievementsSummaryCell.self, forCellReuseIdentifier: AchievementsSummaryCell.identifier)
        self.dataSource = self
        self.delegate = self

        self.tableFooterView = UIView(frame: .zero)
    }
}

extension GameInfoTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

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
        switch sections[indexPath.section] {
        case .gameInfo:
            return GameInfoCell.preferredHeight
        case .achievementsSummary:
            return AchievementsSummaryCell.preferredHeight
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let title = getSectionTitle(for: section), !title.isEmpty else {
            return 0
        }
        return ApSectionTitleView.preferredHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = getSectionTitle(for: section), !title.isEmpty else {
            return nil
        }

        let view = ApSectionTitleView(text: title)
        addViewForStylizing(view)

        return view
    }

    private func getSectionTitle(for section: Int) -> String? {
        switch sections[section] {
        case .gameInfo(let viewModel):
            return viewModel.title
        case .achievementsSummary(let viewModel):
            return viewModel.title
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .gameInfo:
            return tableView.dequeueReusableCell(withIdentifier: GameInfoCell.identifier, for: indexPath)
        case .achievementsSummary:
            return tableView.dequeueReusableCell(withIdentifier: AchievementsSummaryCell.identifier, for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let gameInfoCell = cell as? GameInfoCell {
            gameInfoCell.configure(gameInfoSection.content)
            addViewForStylizing(gameInfoCell)
        }
        if let achievementsSummaryCell = cell as? AchievementsSummaryCell {
            achievementsSummaryCell.configure(achievementsSummarySection.content)
            addViewForStylizing(achievementsSummaryCell)
        }
    }
}
