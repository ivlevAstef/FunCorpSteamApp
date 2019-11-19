//
//  ApTabBarController.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 19/11/2019.
//

import UIKit
import Design

open class ApTabBarController: UITabBarController
{
    public private(set) lazy var style: Style = styleMaker.makeStyle(for: self)

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
