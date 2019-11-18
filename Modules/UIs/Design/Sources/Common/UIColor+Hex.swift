//
//  UIColor+Hex.swift
//  Design
//
//  Created by Alexander Ivlev on 25/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

extension UIColor
{
    public convenience init(hex24 hex: UInt32, alpha: CGFloat = 1.0) {
        let r: UInt32 = (hex >> 16) & 0x000000FF
        let g: UInt32 = (hex >> 8) & 0x000000FF
        let b: UInt32 = (hex >> 0) & 0x000000FF
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    public convenience init(hex32 hex: UInt32) {
        let r: UInt32 = (hex >> 24) & 0x000000FF
        let g: UInt32 = (hex >> 16) & 0x000000FF
        let b: UInt32 = (hex >> 8) & 0x000000FF
        let a: UInt32 = (hex >> 0) & 0x000000FF
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
}

func color(hex24: UInt32, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(hex24: hex24, alpha: alpha)
}

func color(hex32: UInt32) -> UIColor {
    return UIColor(hex32: hex32)
}

func gradient(from: UInt32, to: UInt32) -> Gradient {
    return Gradient(from: UIColor(hex24: from), to: UIColor(hex24: to))
}
