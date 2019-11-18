//
//  NavigationSearchBarAccessoryView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 10/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import UIKit
import Design

private enum Consts {
    static let height: CGFloat = 50.0
    static let iconSize: CGSize = CGSize(width: 20.0, height: 30.0)
    static let cornerRadius: CGFloat = 8.0
}

public final class NavigationSearchBarAccessoryView: UIView, INavigationBarAccessoryView {
    public let fullyHeight: CGFloat = Consts.height
    public let canHidden: Bool = true

    public var placeholder: String? {
        set { textField.placeholder = newValue }
        get { textField.placeholder }
    }

    public var inBackgroundColor: UIColor? {
        set { background.backgroundColor = newValue }
        get { background.backgroundColor }
    }

    public var inTintColor: UIColor? {
        set { textField.textColor = newValue }
        get { textField.textColor }
    }

    public var font: UIFont? {
        set { textField.font = newValue }
        get { textField.font }
    }

    private let background: UIView = UIView(frame: .zero)
    private let icon: UIView = UIView(frame: .zero)
    private let textField: UITextField = UITextField(frame: .zero)

    public init() {
        super.init(frame: .zero)

        addSubview(background)
        background.addSubview(icon)
        background.addSubview(textField)
        clipsToBounds = true

        background.layer.cornerRadius = Consts.cornerRadius
        textField.clearButtonMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func recalculateViews(for t: CGFloat) {
        background.alpha = max(0.0, ((t * 8.0) - 1.0) / 7.0)
        icon.alpha = max(0.0, (t * 3.0) - 2.0)
        textField.alpha = icon.alpha

        background.frame = CGRect(x: 0.0,
                                  y: 8.0,
                                  width: bounds.width,
                                  height: max(0.0, fullyHeight * t - 16.0))

        icon.frame = CGRect(x: 4.0,
                            y: (background.frame.height - Consts.iconSize.height) * 0.5,
                            width: Consts.iconSize.width,
                            height: Consts.iconSize.height)

        let lineHeight = textField.font?.lineHeight ?? 0.0
        textField.frame = CGRect(x: icon.frame.maxX + 4.0,
                                 y: (background.frame.height - lineHeight) * 0.5,
                                 width: background.frame.width - icon.frame.maxX - 4.0,
                                 height: lineHeight)

        textField.endEditing(true)
    }
}

extension NavigationSearchBarAccessoryView: StylizingView {
    public func apply(use style: Style) {
        backgroundColor = .clear
        inBackgroundColor = style.colors.accent.withAlphaComponent(0.3)
        inTintColor = style.colors.mainText
        font = style.fonts.subtitle
    }
}

