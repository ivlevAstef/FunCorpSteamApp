//
//  NavigationSteamProfileAccessoryView.swift
//  AppUIComponents
//
//  Created by Alexander Ivlev on 25/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import UIKit
import Design
import UIComponents
import Services

private enum Consts {
    static let height: CGFloat = 50.0
}

public final class NavigationSteamProfileAccessoryView: UIView, INavigationBarAccessoryView {
    public var fullyHeight: CGFloat {
        if nameLabel.text?.isEmpty ?? true {
            return 0
        }
        return Consts.height
    }
    public let canHidden: Bool = true

    private let nameLabel: UILabel = UILabel(frame: .zero)

    public init() {
        super.init(frame: .zero)

        addSubview(nameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setProfile(_ profile: SteamProfile) {
        var realName: String = ""
        switch profile.visibilityState {
        case .private:
            break
        case .open(let data):
            realName = data.realName ?? ""
        }

        nameLabel.text = "Alexander" //realName
    }

    public func recalculateViews(for t: CGFloat) {
        nameLabel.alpha = max(0.0, ((t * 8.0) - 1.0) / 7.0)
        //nameLabel.alpha = max(0.0, (t * 3.0) - 2.0)

        let lineHeight = nameLabel.font?.lineHeight ?? 0.0
        nameLabel.frame = CGRect(x: 0.0,
                                 y: 8.0,
                                 width: bounds.width,
                                 height: lineHeight)
    }
}

extension NavigationSteamProfileAccessoryView: StylizingView {
    public func apply(use style: Style) {
        backgroundColor = .clear

        nameLabel.font = style.fonts.title
        nameLabel.textColor = style.colors.mainText
    }
}

