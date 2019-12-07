//
//  CustomGameInfoViewContract.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents

public protocol CustomTableCellConfigurator: class
{
    var registeredCell: (type: UITableViewCell.Type, identifier: String) { get }
    var isSelectable: Bool { get }

    func calculateHeightCell() -> CGFloat
    func makeCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func configureCell(_ cell: UITableViewCell)

    func select()
}
