//
//  ScrollableView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 25/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

@objc
public protocol ScrollableView: class {
    var scrollDelegate: UIScrollViewDelegate? { set get }
}

