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
    public var navStatusBar: INavigationBar! {
        return stylizingNavBar.navStatusBar
    }

    public private(set) lazy var style: Style = styleMaker.makeStyle(for: self)

    private let stylizingNavBar: StylizingNavBar
    private let styleMaker: StyleMaker = StyleMaker()

    private var viewsForStylizing: [Weak<StylizingView>] = []

    public init(navStatusBar: (UIView & INavigationBar)?) {
        self.stylizingNavBar = StylizingNavBar(navStatusBar: navStatusBar)
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

        if let navStatusBar = stylizingNavBar.navStatusBar {
            view.addSubview(navStatusBar)
            navStatusBar.frame = .zero
        }

        addViewForStylizing(stylizingNavBar)
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let navStatusBar = stylizingNavBar.navStatusBar {
            view.bringSubviewToFront(navStatusBar)
            if abs(navStatusBar.frame.width - view.bounds.width) > 0.1 {
                navStatusBar.frame.size.width = view.bounds.width

                navStatusBar.update(force: true)
            }
        }
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        style = styleMaker.makeStyle(for: self)
        styleDidChange(style)
    }
}

private class StylizingNavBar: StylizingView {
    let navStatusBar: (UIView & INavigationBar)?

    init(navStatusBar: (UIView & INavigationBar)?) {
        self.navStatusBar = navStatusBar
    }

    func apply(use style: Style) {
        navStatusBar?.update(layout: style.layout.navLayout)
        navStatusBar?.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: style.colors.blurStyle))
    }
}
