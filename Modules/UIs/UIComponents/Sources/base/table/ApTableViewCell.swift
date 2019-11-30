//
//  ApTableViewCell.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 26/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import Common

open class ApTableViewCell: UITableViewCell, StylizingView
{
    public var stylizingSubviews = WeakArray<StylizingView>()

    open func apply(use style: Design.Style) {
        self.backgroundColor = style.colors.accent

        selectionStyle = .default
        let selectedView = UIView()
        selectedView.backgroundColor = style.colors.separator
        selectedBackgroundView = selectedView
    }
}
