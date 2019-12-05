//
//  DotaLastGameConfigurator.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 05/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents

final class DotaLastGameConfigurator: CustomTableCellConfigurator
{
    var lastGameViewModel: SkeletonViewModel<DotaLastGameViewModel> = .loading

    var registeredCell: (type: UITableViewCell.Type, identifier: String) {
        return (type: DotaLastGameCell.self, identifier: DotaLastGameCell.identifier)
    }

    func calculateHeightCell() -> CGFloat {
        return DotaLastGameCell.preferredHeight
    }

    func makeCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: DotaLastGameCell.identifier, for: indexPath)
    }

    func configureCell(_ cell: UITableViewCell) {
        if let lastGameCell = cell as? DotaLastGameCell {
            lastGameCell.configure(lastGameViewModel)
            return
        }
    }
}
