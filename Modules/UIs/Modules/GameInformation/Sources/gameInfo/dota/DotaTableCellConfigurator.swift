//
//  DotaTableCellConfigurator.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents

final class DotaTableCellConfigurator: CustomTableCellConfigurator
{
    var realViewModel: Any?

    var registeredCell: (type: UITableViewCell.Type, identifier: String) {
        return (type: CustomDotaCell.self, identifier: CustomDotaCell.identifier)
    }

    func calculateHeightCell() -> CGFloat {
        return CustomDotaCell.preferredHeight
    }

    func makeCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: CustomDotaCell.identifier, for: indexPath)
    }

    func configureCell(_ cell: UITableViewCell, viewModel: SkeletonViewModel<Void>) {
        if let dotaCell = cell as? CustomDotaCell {
            //dotaCell.configure()
            return
        }
    }
}
