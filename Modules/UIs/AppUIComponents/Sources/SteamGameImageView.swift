//
//  SteamGameImageView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents
import Design

public class SteamGameImageView: IdImageView
{
    public func apply(use style: Style, size: CGFloat) {
        layer.cornerRadius = 0.1 * size
        clipsToBounds = true
    }
}