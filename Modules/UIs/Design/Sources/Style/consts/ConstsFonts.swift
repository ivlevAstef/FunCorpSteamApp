//
//  ConstsFonts.swift
//  Design
//
//  Created by Alexander Ivlev on 25/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

public enum ConstsFonts
{
    public static let `default` = Style.Fonts(
        navLarge: UIFont.systemFont(ofSize: 36.0),
        navDefault: UIFont.systemFont(ofSize: 30.0),
        large: UIFont.systemFont(ofSize: 36.0),
        avatar: UIFont.systemFont(ofSize: 20.0, weight: .bold),
        title: UIFont.systemFont(ofSize: 24.0),
        subtitle: UIFont.systemFont(ofSize: 16.0),
        content: UIFont.systemFont(ofSize: 16.0)
    )
}
