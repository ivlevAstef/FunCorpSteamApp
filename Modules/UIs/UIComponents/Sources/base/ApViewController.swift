//
//  ApViewController.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 26/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import Common

open class ApViewController: UIViewController {
    public private(set) lazy var style: Style = styleMaker.makeStyle(for: self)

    private let styleMaker: StyleMaker = StyleMaker()

    private var viewsForStylizing: [Weak<StylizingView>] = []

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addViewForStylizing(_ view: StylizingView, immediately: Bool = true) {
        viewsForStylizing.append(Weak(view))
        if immediately {
            view.apply(use: style)
        }
    }

    open func styleDidChange(_ style: Style) {
        view.backgroundColor = style.colors.background

        viewsForStylizing.removeAll { $0.value == nil }
        for refStylizingView in viewsForStylizing.reversed() {
            refStylizingView.value?.apply(use: style)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        styleDidChange(style)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        style = styleMaker.makeStyle(for: self)
        styleDidChange(style)
    }
}
