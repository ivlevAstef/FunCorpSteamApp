//
//  NavigationCenterTextView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 05/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import Common

public final class NavigationCenterTextView: UIView, INavigationBarCenterView
{
    public var text: String {
        set { label.text = newValue }
        get { return label.text ?? "" }
    }

    public var textColor: UIColor {
        set { label.textColor = newValue }
        get { return label.textColor ?? .clear }
    }

    public var defaultFont: UIFont?
    public var largeFont: UIFont?

    private let label = UILabel(frame: .zero)

    public init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        addSubview(label)
    }

    public func recalculateViews(for t: CGFloat) {
        guard let defaultFont = defaultFont, let largeFont = largeFont else {
            log.assert("For use nav center label view your need setup fonts")
            return
        }

        var font = defaultFont
        if t > 1.75 {
            font = largeFont
        }

        if t >= 1.0 {
            let fontSize = (t - 1.0) * largeFont.pointSize + defaultFont.pointSize * (2.0 - t)
            font = font.withSize(fontSize)
        } else {
            let fontSize = t * (defaultFont.pointSize - defaultFont.pointSize * 0.75) + defaultFont.pointSize * 0.75
            font = font.withSize(fontSize)
        }

        label.font = font
        label.sizeToFit()

        label.frame.origin.x = 4.0
        label.frame.origin.y = frame.height - label.frame.height
        label.frame.size.width = frame.width
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationCenterTextView: StylizingView {
    public func apply(use style: Style) {
        textColor = style.colors.mainText
        defaultFont = style.fonts.navDefault
        largeFont = style.fonts.navLarge
    }
}
