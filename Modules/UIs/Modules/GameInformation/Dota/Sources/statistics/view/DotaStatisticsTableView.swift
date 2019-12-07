//
//  DotaStatisticsTableView.swift
//  Dota
//
//  Created by Alexander Ivlev on 07/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import SnapKit
import Design
import UIComponents

final class DotaStatisticsTableView: ApTableView
{
    private var statisticViewModels: [DotaStatisticViewModel] = []

    init() {
        super.init(frame: .zero, style: .grouped)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateStatistics(_ viewModels: [DotaStatisticViewModel]) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        statisticViewModels = viewModels
        reloadData()
    }

    private func commonInit() {
        register(DotaStatisticCell.self, forCellReuseIdentifier: DotaStatisticCell.identifier)
        self.dataSource = self
        self.delegate = self

        self.tableFooterView = UIView(frame: .zero)
    }

    public override func apply(use style: Design.Style) {
        super.apply(use: style)

        separatorColor = style.colors.background
    }
}

extension DotaStatisticsTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return statisticViewModels.count
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
        return DotaStatisticCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return statisticViewModels[section].title.isEmpty ? 0.0 : ApSectionTitleView.preferredHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = statisticViewModels[section].title
        if title.isEmpty {
            return nil
        }

        let view = ApSectionTitleView(text: title)
        addViewForStylizing(view)

        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: DotaStatisticCell.identifier, for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let statisticCell = cell as? DotaStatisticCell {
            statisticCell.configure(statisticViewModels[indexPath.section])
            addViewForStylizing(statisticCell)
        }
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
