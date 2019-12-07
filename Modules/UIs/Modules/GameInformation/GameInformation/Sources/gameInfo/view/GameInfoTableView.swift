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

    // Для массива
    private enum TypedSection {
        case gameInfo(Section<GameInfoViewModel>)
        case achievementsSummary(Section<AchievementsSummaryViewModel?>)
        case custom(configurators: [CustomTableCellConfigurator], title: String?)
    }
    private var sections: [TypedSection] = []

    private var gameInfoSection = Section<GameInfoViewModel>(content: .loading)
    private var achievementsSummarySection = Section<AchievementsSummaryViewModel?>(content: .loading)

    private var customSections: [UInt: TypedSection] = [:]

    private var registeredCells: Set<String> = []

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

    func updateAchievementSummary(_ achievementsSummary: SkeletonViewModel<AchievementsSummaryViewModel?>) {
        achievementsSummarySection.content = achievementsSummary
        updateSections()
        reloadData()
    }

    func addCustomSection(title: String?, order: UInt, configurators: [CustomTableCellConfigurator]) {
        log.assert(customSections[order] == nil, "call add custom section for order: \(order) but this section haven")
        for configurator in configurators {
            let (type, identifier) = configurator.registeredCell
            registerIfNeeded(type, identifier: identifier)
        }

        customSections[order] = .custom(configurators: configurators, title: title)
    }

    func removeCustomSection(order: UInt) {
        customSections.removeValue(forKey: order)
    }

    func updateCustom(configurator: CustomTableCellConfigurator) {
        let saveContentOffset = contentOffset

        beginUpdates()
// TODO: reload менее красиво, зато обновляет нормально - а то reloadRows с .none, чет подглючивает
//        for (sectionIndex, section) in sections.enumerated() {
//            guard case .custom(let configurators, _) = section else {
//                continue
//            }
//
//            if let row = configurators.firstIndex(where: { $0 === configurator }) {
//                reloadRows(at: [IndexPath(row: Int(row), section: Int(sectionIndex))], with: .fade)
//            }
//        }
        reloadData()
        endUpdates()

        /// Убираем подергивание при обновлении...
        ..layer.removeAllAnimations()
        setContentOffset(saveContentOffset, animated: false)
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
        registerIfNeeded(GameInfoCell.self, identifier: GameInfoCell.identifier)
        registerIfNeeded(AchievementsSummaryCell.self, identifier: AchievementsSummaryCell.identifier)
        // Custom cell registered after add section
        self.dataSource = self
        self.delegate = self

        self.tableFooterView = UIView(frame: .zero)
    }

    private func registerIfNeeded(_ type: UITableViewCell.Type, identifier: String) {
        if registeredCells.contains(identifier) {
            return
        }
        registeredCells.insert(identifier)
        register(type, forCellReuseIdentifier: identifier)
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
        case .custom(let configurators, _):
            return configurators.count
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
        case .custom(let configurators, _):
            return configurators[indexPath.row].calculateHeightCell()
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
        case .custom(_, let title):
            return title
        }
    }

    // MARK: table content

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .gameInfo:
            return tableView.dequeueReusableCell(withIdentifier: GameInfoCell.identifier, for: indexPath)
        case .achievementsSummary:
            return tableView.dequeueReusableCell(withIdentifier: AchievementsSummaryCell.identifier, for: indexPath)
        case .custom(let configurators, _):
            return configurators[indexPath.row].makeCell(in: tableView, indexPath: indexPath)
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

        if case let .custom(configurators, _) = sections[indexPath.section] {
            configurators[indexPath.row].configureCell(cell)
            if let stylizingView = cell as? StylizingView {
                addViewForStylizing(stylizingView)
            }
        }
    }

    // MARK: - selection

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return shouldHighlightRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if shouldHighlightRow(at: indexPath) {
            return indexPath
        }
        return nil
    }

    private func shouldHighlightRow(at indexPath: IndexPath) -> Bool {
        switch sections[indexPath.section] {
        case .gameInfo:
            return false
        case .achievementsSummary:
            return false
        case .custom(let configurators, _):
            return configurators[indexPath.row].isSelectable
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .gameInfo:
            break
        case .achievementsSummary:
            break
        case .custom(let configurators, _):
            configurators[indexPath.row].select()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
