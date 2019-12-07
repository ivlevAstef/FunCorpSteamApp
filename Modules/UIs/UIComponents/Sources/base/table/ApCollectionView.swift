//
//  ApCollectionView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 08/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import Common

open class ApCollectionView: UICollectionView, StylizingView
{
    private let stylizingViewsContainer = StylizingViewsContainer()

    public func addViewForStylizing(_ view: StylizingView, immediately: Bool = true) {
        stylizingViewsContainer.addView(view, immediately: immediately)
    }

    open func apply(use style: Design.Style) {
        backgroundColor = style.colors.background

        stylizingViewsContainer.styleDidChange(style)
    }
}
