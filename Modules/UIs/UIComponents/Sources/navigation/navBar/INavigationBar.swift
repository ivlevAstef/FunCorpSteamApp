//
//  INavigationBar.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 05/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design

public enum NavigationBarInitialDisplayMode {
    case hide
    case `default`
    case large
}

public enum NavigationBarDisplayMode {
    /// any time navigation bar is hide
    case hide
    /// any time navigation bar is default height
    case `default`
    /// any time navigation bar is large height
    case large
    /// can changed hide-default range
    case smallAuto
    /// can changed default-large range
    case largeAuto
    /// can changed hide-large range
    case fullyAuto
}

public struct NavigationBarLayout
{
    public let statusBarHeight: CGFloat
    public let navigationBarDefaultHeight: CGFloat
    /// Can be 0.0 - if this rotation or screen size not support larget height
    public let navigationBarLargeHeight: CGFloat

    public let leftInset: CGFloat
    public let rightInset: CGFloat
    public let bottomInset: CGFloat

    public init(statusBarHeight: CGFloat,
                navigationBarDefaultHeight: CGFloat,
                navigationBarLargeHeight: CGFloat,
                leftInset: CGFloat,
                rightInset: CGFloat,
                bottomInset: CGFloat) {
        self.statusBarHeight = statusBarHeight
        self.navigationBarDefaultHeight = navigationBarDefaultHeight
        self.navigationBarLargeHeight = navigationBarLargeHeight
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.bottomInset = bottomInset
    }
}


public protocol INavigationBarCenterView {
    /// called if need recalculate subviews or properties
    /// - Parameter t: hide == 0, default == 1, large == 2, more == 2...3
    func recalculateViews(for t: CGFloat)
}

public protocol INavigationBarAccessoryView {
    var fullyHeight: CGFloat { get }
    var canHidden: Bool { get }
    /// called if need recalculate subviews or properties
    /// - Parameter t: hide == 0, fully == 1
    func recalculateViews(for t: CGFloat)
}

public protocol INavigationBarItemView {
    var width: CGFloat { get }
    
    /// called if need recalculate subviews or properties
    /// - Parameter t: hide == 0, default == 1, large == 2, more == 2...3
    func recalculateViews(for t: CGFloat)
}

public protocol INavigationBar: class {
    var initialDisplayMode: NavigationBarInitialDisplayMode { get set }
    var displayMode: NavigationBarDisplayMode { get set }
    /// preferred height - use this height for calculate real height taking display mode
    var preferredHeight: CGFloat { get set }

    /// min navigation bar height. Calculated use display mode
    var minHeight: CGFloat { get }
    /// max navigation bar height. Calculated use display mode
    var maxHeight: CGFloat { get }

    /// left items. Before set items setup his width.
    var leftItems: [UIView & INavigationBarItemView] { get set }
    /// right items. Before set items setup his width.
    var rightItems: [UIView & INavigationBarItemView] { get set }
    /// `true` if needs right items glue to bottom. it's Actually only with large display mode. Default - `false`
    var rightItemsGlueBottom: Bool { get set }

    /// additional views under navigation bar. Before set items setup his height.
    var accessoryItems: [UIView & INavigationBarAccessoryView] { get set }

    var backgroundView: UIView? { get set }
    var centerContentView: (UIView & INavigationBarCenterView)? { get set }

    func calculatePreferredHeight(targetHeight: CGFloat) -> CGFloat

    func update(force: Bool)
    func update(layout: NavigationBarLayout)

    func bind(to scrollView: UIScrollView)
}

extension INavigationBar {
    public func update() {
        update(force: false)
    }
}

extension Style.Layout {
    public var navLayout: NavigationBarLayout {
        return NavigationBarLayout(statusBarHeight: statusBarHeight,
                                   navigationBarDefaultHeight: navigationBarDefaultHeight,
                                   navigationBarLargeHeight: navigationBarLargeHeight,
                                   leftInset: innerInsets.left + safeAreaInsets.left,
                                   rightInset: innerInsets.right + safeAreaInsets.right,
                                   bottomInset: 6.0)
    }
}
