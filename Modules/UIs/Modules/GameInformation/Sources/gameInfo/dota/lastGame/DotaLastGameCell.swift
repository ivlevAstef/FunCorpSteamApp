//
//  DotaLastGameCell.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 05/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents
import AppUIComponents
import SnapKit


final class DotaLastGameCell: ApTableViewCell
{
    static let preferredHeight: CGFloat = 100.0
    static let identifier = "\(DotaLastGameCell.self)"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: SkeletonViewModel<DotaLastGameViewModel>) {
    }

    private func commonInit() {

    }



    override func apply(use style: Style) {
        super.apply(use: style)

        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
    }
}
