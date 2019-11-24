//
//  ApTableView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 25/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

open class ApTableView: UITableView, ScrollableView, UIScrollViewDelegate {
    open weak var scrollDelegate: UIScrollViewDelegate? {
        set { _scrollDelegate = newValue }
        get { _scrollDelegate }
    }

    private weak var _scrollDelegate: UIScrollViewDelegate?

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }

    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
