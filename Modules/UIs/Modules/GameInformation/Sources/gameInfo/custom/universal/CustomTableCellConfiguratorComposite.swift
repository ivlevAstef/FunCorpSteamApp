//
//  CustomTableCellConfigurator.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import UIComponents

/// Класс который помогает, отображать кастомную ячейку.
final class CustomTableCellConfiguratorComposite
{
    private let configurators: [CustomViewModelStyle: CustomTableCellConfigurator]

    init(configurators: [CustomTableCellConfigurator]) {
        var dict: [CustomViewModelStyle: CustomTableCellConfigurator] = [:]
        for configurator in configurators {
            let style = configurator.style
            log.assert(dict[style] == nil, "Your register two cell configurators for one style: \(style)")
            dict[style] = configurator
        }

        self.configurators = dict
    }

    func registerCells(in tableView: UITableView) {
        for configurator in configurators.values {
            configurator.registerCell(in: tableView)
        }
    }

    func heightCell(_ style: CustomViewModelStyle, indexPath: IndexPath) -> CGFloat {
        return configurators[style]!.heightCell(indexPath: indexPath)
    }

    func makeCell(in tableView: UITableView, style: CustomViewModelStyle, indexPath: IndexPath) -> UITableViewCell {
        configurators[style]!.makeCell(in: tableView, indexPath: indexPath)
    }

    func configureCell(_ cell: UITableViewCell,
                       style: CustomViewModelStyle,
                       viewModel: SkeletonViewModel<CustomViewModel>) {
        configurators[style]!.configureCell(cell, viewModel: viewModel)
    }

}
