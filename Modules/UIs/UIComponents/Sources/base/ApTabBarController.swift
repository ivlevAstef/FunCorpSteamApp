//
//  ApTabBarController.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design

open class ApTabBarController: UITabBarController
{
    public private(set) lazy var style: Style = styleMaker.makeStyle(for: self)

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let tabVCs = viewControllers, !tabVCs.isEmpty else {
            return style.colors.preferredStatusBarStyle
        }
        return tabVCs[selectedIndex].preferredStatusBarStyle
    }

    private let styleMaker: StyleMaker = StyleMaker()

    open func styleDidChange(_ style: Style) {
        view.backgroundColor = style.colors.background
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        style = styleMaker.makeStyle(for: self)
        styleDidChange(style)
    }
}
