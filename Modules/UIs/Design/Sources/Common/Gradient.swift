//
//  Gradient.swift
//  Design
//
//  Created by Alexander Ivlev on 25/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

public struct Gradient
{
    public let from: UIColor
    public let to: UIColor

    public init(from: UIColor, to: UIColor) {
        self.from = from
        self.to = to
    }
}
