//
//  Dota2WeeksSummaryConfigurator.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 05/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents

final class Dota2WeeksSummaryConfigurator: CustomTableCellConfigurator
{
    var gamesCountViewModel: SkeletonViewModel<Dota2WeeksGamesCountViewModel> = .loading
    var detailsViewModel: SkeletonViewModel<Dota2WeeksDetailsViewModel> = .loading

    var registeredCell: (type: UITableViewCell.Type, identifier: String) {
        return (type: DotaLast2WeeksSummaryCell.self, identifier: DotaLast2WeeksSummaryCell.identifier)
    }

    func calculateHeightCell() -> CGFloat {
        return DotaLast2WeeksSummaryCell.preferredHeight
    }

    func makeCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: DotaLast2WeeksSummaryCell.identifier, for: indexPath)
    }

    func configureCell(_ cell: UITableViewCell) {
        if let summaryCell = cell as? DotaLast2WeeksSummaryCell {
            summaryCell.configure(gamesCountViewModel)
            summaryCell.configure(detailsViewModel)
            return
        }
    }
}
