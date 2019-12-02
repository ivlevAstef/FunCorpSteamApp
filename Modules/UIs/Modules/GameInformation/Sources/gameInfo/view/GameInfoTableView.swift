//
//  GameInfoTableView.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import UIComponents
import Design

class GameInfoTableView: ApTableView
{
    typealias Section<T> = ApTableView.TableSection<SkeletonViewModel<T>>
    typealias CustomSection = TableSection<[SkeletonViewModel<CustomViewModel>]>

    // Для массива
    private enum TypedSection {
        case gameInfo(Section<GameInfoViewModel>)
        case achievementsSummary(Section<AchievementsSummaryViewModel?>)
        case custom(styles: [CustomViewModelStyle], section: CustomSection)
    }
    private var sections: [TypedSection] = []

    private var gameInfoSection = Section<GameInfoViewModel>(content: .loading)
    private var achievementsSummarySection = Section<AchievementsSummaryViewModel?>(content: .loading)

    private let customCellConfigurator: CustomTableCellConfiguratorComposite

    private var customSections: [UInt: TypedSection] = [:]

    init(cellConfigurator: CustomTableCellConfiguratorComposite) {
        customCellConfigurator = cellConfigurator
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

    func updateAchievementSummary(_ achievementsSummary: SkeletonViewModel<AchievementsSummaryViewModel?>) {
        achievementsSummarySection.content = achievementsSummary
        updateSections()
        reloadData()
    }

    func addCustomSection(title: String?, order: UInt, styles: [CustomViewModelStyle]) {
        log.assert(customSections[order] == nil, "call add custom section for order: \(order) but this section haven")
        var section = CustomSection(content: Array(repeating: .loading, count: styles.count))
        section.title = title

        customSections[order] = .custom(styles: styles, section: section)
    }

    func removeCustomSection(order: UInt) {
        customSections.removeValue(forKey: order)
    }

    func updateCustom(_ custom: SkeletonViewModel<CustomViewModel>, order: UInt, row: UInt) {
        guard case .custom(let styles, var section) = customSections[order] else {
            log.assert("Can't found custom section, or section incorret by order: \(order)")
            return
        }

        section.content[Int(row)] = custom
        customSections[order] = .custom(styles: styles, section: section)

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

        let orders = Set(customSections.keys).sorted()
        for order in orders {
            guard let section = customSections[order] else {
                log.assert("WTF... not found custom section, but order in table")
                continue
            }

            newSections.append(section)
        }

        sections = newSections
    }

    private func commonInit() {
        register(GameInfoCell.self, forCellReuseIdentifier: GameInfoCell.identifier)
        register(AchievementsSummaryCell.self, forCellReuseIdentifier: AchievementsSummaryCell.identifier)
        customCellConfigurator.registerCells(in: self)
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
        switch sections[section] {
        case .gameInfo:
            return 1
        case .achievementsSummary:
            return 1
        case .custom(let styles, _):
            return styles.count
        }
    }

    // MARK:  height

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
        case .custom(let styles, _):
            return customCellConfigurator.calculateHeightCell(styles[indexPath.row])
        }
    }

    // MARK:  section title

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
        case .custom(_, let section):
            return section.title
        }
    }

    // MARK: table content

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .gameInfo:
            return tableView.dequeueReusableCell(withIdentifier: GameInfoCell.identifier, for: indexPath)
        case .achievementsSummary:
            return tableView.dequeueReusableCell(withIdentifier: AchievementsSummaryCell.identifier, for: indexPath)
        case .custom(let styles, _):
            return customCellConfigurator.makeCell(in: tableView, style: styles[indexPath.row], indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let gameInfoCell = cell as? GameInfoCell {
            gameInfoCell.configure(gameInfoSection.content)
            addViewForStylizing(gameInfoCell)
            return
        }

        if let achievementsSummaryCell = cell as? AchievementsSummaryCell {
            achievementsSummaryCell.configure(achievementsSummarySection.content)
            addViewForStylizing(achievementsSummaryCell)
            return
        }

        if case let .custom(styles, section) = sections[indexPath.section] {
            customCellConfigurator.configureCell(cell,
                                                 style: styles[indexPath.row],
                                                 viewModel: section.content[indexPath.row])
            if let stylizingView = cell as? StylizingView {
                addViewForStylizing(stylizingView)
            }
        }
    }
}
