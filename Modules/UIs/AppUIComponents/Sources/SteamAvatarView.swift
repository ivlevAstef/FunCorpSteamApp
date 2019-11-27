//
//  SteamAvatarView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents
import Design

public final class SteamAvatarView: AvatarView
{
}

extension SteamAvatarView: StylizingView
{
    public func apply(use style: Style) {
        layer.shadowColor = style.colors.shadowColor.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.0
        layer.shadowOpacity = style.colors.shadowOpacity
    }
}
