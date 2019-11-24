//
//  NavigationSteamAvatarView.swift
//  AppUIComponents
//
//  Created by Alexander Ivlev on 28/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import UIComponents
import Design

private enum Consts {
    static let maxSize: CGFloat = 60.0
}

public class NavigationSteamAvatarView: UIView, INavigationBarItemView {
    public let width: CGFloat = Consts.maxSize

    private let avatarView = AvatarView(size: Consts.maxSize)

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: Consts.maxSize, height: Consts.maxSize))
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(letter: String) {
        avatarView.setup(letter: letter)
    }

    public func setup(_ image: ChangeableImage, letter: String? = nil) {
        avatarView.setup(image, letter: letter)
    }

    public func recalculateViews(for t: CGFloat) {
        let size = min(frame.width, frame.height)

        avatarView.size = size
        avatarView.frame.origin = CGPoint(x: frame.width - size, y: frame.height - size)

        avatarView.setNeedsDisplay()
    }

    private func initialize() {
        backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarView)
    }
}

extension NavigationSteamAvatarView: StylizingView
{
    public func apply(use style: Style) {
        avatarView.layer.shadowColor = style.colors.shadowColor.cgColor
        avatarView.layer.shadowOffset = .zero
        avatarView.layer.shadowRadius = 4.0
        avatarView.layer.shadowOpacity = style.colors.shadowOpacity
        avatarView.cornerRadius = 4.0

        avatarView.apply(use: style)
    }
}
