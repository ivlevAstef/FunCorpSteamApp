//
//  StylizingViewsContainer.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 26/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common

public final class StylizingViewsContainer
{
    private var style: Style?

    private var viewsForStylizing = WeakArray<StylizingView>()

    public init() {

    }

    public func addView(_ view: StylizingView, immediately: Bool) {
        if viewsForStylizing.contains(where: { $0 === view }) {
            return
        }

        viewsForStylizing.append(view)
        if let style = style, immediately {
            view.apply(use: style)
            apply(style, viewsForStylizing: view.stylizingSubviews)
        }
    }

    public func styleDidChange(_ style: Style) {
        self.style = style

        apply(style, viewsForStylizing: viewsForStylizing)
    }

    private func apply(_ style: Style, viewsForStylizing: WeakArray<StylizingView>) {
        for stylizingView in viewsForStylizing.reversed() {
            stylizingView.apply(use: style)
            apply(style, viewsForStylizing: stylizingView.stylizingSubviews)
        }
    }
}
