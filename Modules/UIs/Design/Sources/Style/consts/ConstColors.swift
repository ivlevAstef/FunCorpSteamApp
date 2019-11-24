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
        separator: color(hex24: 0x222222),
        tint: color(hex24: 0xFFFFFF),
        skeleton: gradient(from: 0x39383e, to: 0x707070),
        skeletonFailed: color(hex24: 0xc73225),
        mainText: color(hex24: 0xFFFFFF),
        notAccentText: color(hex24: 0xc3c3c3),
        contentText: color(hex24: 0xc3c3c3),
        blurStyle: .dark,

        shadowColor: color(hex24: 0x000000),
        shadowOpacity: 1.0
    )

    public static let lightColors = Style.Colors(
        background: color(hex24: 0xFFFFFF),
        accent: color(hex24: 0xbdbdbd),
        separator: color(hex24: 0xDDDDDD),
        tint: color(hex24: 0xFFFFFF),
        skeleton: gradient(from: 0xbdbdbd, to: 0xe0e0e0),
        skeletonFailed: color(hex24: 0xf64d3f),
        mainText: color(hex24: 0x000000),
        notAccentText: color(hex24: 0x3c3c3c),
        contentText: color(hex24: 0x3c3c3c),
        blurStyle: .light,

        shadowColor: color(hex24: 0x000000),
        shadowOpacity: 1.0
    )
}
