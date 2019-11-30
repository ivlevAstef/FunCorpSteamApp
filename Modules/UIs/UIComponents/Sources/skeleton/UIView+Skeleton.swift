//
//  UIView+Skeleton.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    public func startSkeleton() -> SkeletonView {
        if !subviews.contains(where: { $0 is SkeletonView }) {
            let subview = SkeletonView()
            addSubview(subview)

            subview.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
        }

        let skeletonViews = subviews.compactMap { $0 as? SkeletonView }

        for subview in skeletonViews {
            subview.start()
        }

        return skeletonViews.last!
    }

    public func endSkeleton() {
        let skeletonViews = subviews.compactMap { $0 as? SkeletonView }
        UIView.animate(withDuration: 0.15, animations: {
            for subview in skeletonViews {
                subview.alpha = 0.0
            }
        }, completion: { _ in
            for subview in skeletonViews {
                subview.end()
                subview.removeFromSuperview()
            }
        })
    }

    public func failedSkeleton() {
        let skeletonViews = subviews.compactMap { $0 as? SkeletonView }
        for subview in skeletonViews {
            subview.failed()
        }
    }

}
