//
//  ApTableView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 26/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import Common

open class ApTableView: UITableView, StylizingView
{
    public struct TableSection<Content> {
        public var title: String?
        public var content: Content

        public init(content: Content) {
            self.content = content
        }
    }

    private let stylizingViewsContainer = StylizingViewsContainer()

    public func addViewForStylizing(_ view: StylizingView, immediately: Bool = true) {
        stylizingViewsContainer.addView(view, immediately: immediately)
    }

    open func apply(use style: Design.Style) {
        backgroundColor = style.colors.background
        separatorColor = style.colors.separator

        separatorInset = .zero

        stylizingViewsContainer.styleDidChange(style)
    }
}
