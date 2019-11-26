//
//  StylizingView.swift
//  Design
//
//  Created by Alexander Ivlev on 27/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

public protocol StylizingView: class
{
    var stylizingSubviews: WeakArray<StylizingView> { get }

    func apply(use style: Style)
}

extension StylizingView {
    public var stylizingSubviews: WeakArray<StylizingView> { WeakArray() }
}
