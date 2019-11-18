//
//  ConstColors.swift
//  Design
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

public enum ConstColors
{
    public static let darkColors = Style.Colors(
        background: color(hex24: 0x000000),
        accent: color(hex24: 0x39383e),
        separator: color(hex24: 0x000000),
        tint: color(hex24: 0xFFFFFF),
        mainText: color(hex24: 0xFFFFFF),
        notAccentText: color(hex24: 0xc3c3c3),
        contentText: color(hex24: 0xc3c3c3),
        blurStyle: .dark
    )

    public static let lightColors = Style.Colors(
        background: color(hex24: 0xFFFFFF),
        accent: color(hex24: 0xbdbdbd),
        separator: color(hex24: 0xFFFFFF),
        tint: color(hex24: 0xFFFFFF),
        mainText: color(hex24: 0x000000),
        notAccentText: color(hex24: 0x3c3c3c),
        contentText: color(hex24: 0x3c3c3c),
        blurStyle: .light
    )
}
