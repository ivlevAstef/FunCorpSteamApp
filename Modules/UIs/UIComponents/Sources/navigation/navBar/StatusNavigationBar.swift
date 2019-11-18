//
//  StatusNavigationBar.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 05/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

public class StatusNavigationBar: UIView, INavigationBar
{
    public var initialDisplayMode: NavigationBarInitialDisplayMode {
        set { navBar.initialDisplayMode = newValue; update() }
        get { return navBar.initialDisplayMode }
    }
    public var displayMode: NavigationBarDisplayMode {
        set { navBar.displayMode = newValue; update() }
        get { return navBar.displayMode }
    }
    public var preferredHeight: CGFloat {
        set { navBar.preferredHeight = newValue - statusBarHeight; update() }
        get { return navBar.preferredHeight + statusBarHeight }
    }

    public var minHeight: CGFloat { return navBar.minHeight + statusBarHeight }
    public var maxHeight: CGFloat { return navBar.maxHeight + statusBarHeight }

    public var leftItems: [UIView & INavigationBarItemView] {
        set { navBar.leftItems = newValue }
        get { return navBar.leftItems }
    }
    public var rightItems: [UIView & INavigationBarItemView] {
        set { navBar.rightItems = newValue }
        get { return navBar.rightItems }
    }
    public var rightItemsGlueBottom: Bool {
        set { navBar.rightItemsGlueBottom = newValue }
        get { return navBar.rightItemsGlueBottom }
    }

    public var accessoryItems: [UIView & INavigationBarAccessoryView] {
        set { navBar.accessoryItems = newValue; update() }
        get { return navBar.accessoryItems }
    }

    public var backgroundView: UIView? {
        didSet { updateBackgroundView(prev: oldValue) }
    }

    public var centerContentView: (UIView & INavigationBarCenterView)? {
        set { navBar.centerContentView = newValue; update() }
        get { return navBar.centerContentView }
    }

    private let navBar: NavigationBar = NavigationBar()
    private var statusBarHeight: CGFloat = 44.0
    private var scrollController: ScrollNavigationBarController? {
        set { navBar.scrollController = newValue }
        get { return navBar.scrollController }
    }

    public init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        // I have self background view
        navBar.backgroundView = nil
        addSubview(navBar)

        update(force: true)
    }

    public func calculatePreferredHeight(targetHeight: CGFloat) -> CGFloat {
        return navBar.calculatePreferredHeight(targetHeight: targetHeight - statusBarHeight) + statusBarHeight
    }

    public func update(layout: NavigationBarLayout) {
        navBar.update(layout: layout)

        if layout.statusBarHeight != statusBarHeight {
            statusBarHeight = layout.statusBarHeight
            
            update(force: true)
            scrollController?.update()
        }
    }

    public func update(force: Bool) {
        // for improve configure speed - not need update = not need time
        if abs(frame.size.width) <= 1.0e-3 {
            return
        }

        navBar.frame.origin = CGPoint(x: 0.0, y: statusBarHeight)
        navBar.frame.size.width = frame.size.width

        navBar.update(force: force)

        let newHeight = statusBarHeight + navBar.frame.height

        if !force && abs(newHeight - frame.size.height) < 0.1 {
            return
        }

        frame.size.height = newHeight
        backgroundView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: newHeight)

        setNeedsLayout()
    }

    public func bind(to scrollView: UIScrollView) {
        scrollController = ScrollNavigationBarController(scrollView: scrollView, navBar: self)
    }

    private func updateBackgroundView(prev prevBackgroundView: UIView?) {
        if prevBackgroundView === backgroundView {
            return
        }

        prevBackgroundView?.removeFromSuperview()

        if let backgroundView = backgroundView {
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            insertSubview(backgroundView, at: 0)
        }

        update(force: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
