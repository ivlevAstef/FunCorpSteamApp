//
//  NavigationAvatarView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 28/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design

private enum Consts {
    static let maxSize: CGFloat = 40.0
}

public class NavigationAvatarView: UIView, INavigationBarItemView {
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

    public func setup(_ image: UIImage?) {
        avatarView.setup(image)
    }

    public func setup(_ image: ChangeableImage) {
        avatarView.setup(image)
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

extension NavigationAvatarView: StylizingView
{
    public func apply(use style: Style) {
        avatarView.apply(use: style)
    }
}
