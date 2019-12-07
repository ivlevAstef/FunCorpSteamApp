//
//  DotaStatisticsScreenView.swift
//  Dota
//
//  Created by Alexander Ivlev on 06/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents

final class DotaStatisticsScreenView: ApViewController, DotaStatisticsScreenViewContract
{
    private let tableView = DotaStatisticsTableView()

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = loc["Games.Dota2.GameStatistic.title"]

        configureViews()
    }

    func setStatistics(_ viewModels: [DotaStatisticViewModel]) {
        tableView.updateStatistics(viewModels)
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
