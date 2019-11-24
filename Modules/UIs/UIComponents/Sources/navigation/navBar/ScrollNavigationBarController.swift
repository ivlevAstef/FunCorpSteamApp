//
//  ScrollNavigationBarController.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 05/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

import Common

final class ScrollNavigationBarController: NSObject, UIScrollViewDelegate {

    private let scrollView: ScrollableView & UIScrollView
    private weak var navBar: INavigationBar?

    init(scrollView: ScrollableView & UIScrollView, navBar: INavigationBar) {
        self.scrollView = scrollView
        self.navBar = navBar

        super.init()

        scrollView.scrollDelegate = self
    }

    func update() {
        setStartedContentInsets(scrollView: scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navBar = navBar else {
            return
        }

        navBar.preferredHeight = -scrollView.contentOffset.y

        if #available(iOS 11.1, *) {
            if -scrollView.contentOffset.y > navBar.minHeight {
                scrollView.verticalScrollIndicatorInsets.top = -scrollView.contentOffset.y - scrollView.topInset
            }
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let navBar = navBar else {
            return
        }

        let distance = calculateMoveDistance(velocity: velocity.y, decelerationRate: scrollView.decelerationRate.rawValue)

        let targetHeight = -scrollView.contentOffset.y - distance
        setContentInsets(scrollView: scrollView, targetHeight: targetHeight)

        if navBar.minHeight <= targetHeight && targetHeight <= navBar.maxHeight {
            let height = scrollView.contentInset.top + scrollView.topInset
            targetContentOffset.pointee = CGPoint(x: 0.0, y: -height)
        }
    }

    private func calculateMoveDistance(velocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return velocity * decelerationRate / (1.0 - decelerationRate)
    }

    private func setStartedContentInsets(scrollView: UIScrollView) {
        guard let navBar = navBar else {
            return
        }

        setContentInsets(scrollView: scrollView, targetHeight: navBar.preferredHeight)
        let height = scrollView.contentInset.top + scrollView.topInset
        scrollView.setContentOffset(CGPoint(x: 0, y: -height), animated: false)
    }

    private func setContentInsets(scrollView: UIScrollView, targetHeight: CGFloat) {
        guard let navBar = navBar else {
            return
        }

        let height = navBar.calculatePreferredHeight(targetHeight: targetHeight)

        let inset = height - scrollView.topInset
        if scrollView.contentInset.top != inset {
            scrollView.contentInset.top = inset
        }

        if #available(iOS 11.1, *) {
            if scrollView.verticalScrollIndicatorInsets.top != inset {
                scrollView.verticalScrollIndicatorInsets.top = inset
            }
        }
    }
}

extension UIScrollView
{
    fileprivate var topInset: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaInsets.top
        } else {
            return 0.0
        }
    }
}
