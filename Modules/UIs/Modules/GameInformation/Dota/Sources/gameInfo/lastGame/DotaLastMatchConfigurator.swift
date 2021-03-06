//
//  DotaLastMatchConfigurator.swift
//  Dota
//
//  Created by Alexander Ivlev on 05/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents
import GameInformation //TODO: CustomGameInformation

final class DotaLastMatchConfigurator: CustomTableCellConfigurator
{
    var lastMatchViewModel: SkeletonViewModel<DotaLastMatchViewModel> = .loading

    let isSelectable: Bool = false

    var registeredCell: (type: UITableViewCell.Type, identifier: String) {
        return (type: DotaLastMatchCell.self, identifier: DotaLastMatchCell.identifier)
    }

    func calculateHeightCell() -> CGFloat {
        return DotaLastMatchCell.preferredHeight
    }

    func makeCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: DotaLastMatchCell.identifier, for: indexPath)
    }

    func configureCell(_ cell: UITableViewCell) {
        if let lastMatchCell = cell as? DotaLastMatchCell {
            lastMatchCell.configure(lastMatchViewModel)
            return
        }
    }

    func select() {
    }
}
