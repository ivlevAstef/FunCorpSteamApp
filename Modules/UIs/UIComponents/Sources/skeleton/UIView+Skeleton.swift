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

        let skeletons = subviews.compactMap({ $0 as? SkeletonView })

        for subview in skeletons {
            subview.start()
        }

        return skeletons.last!
    }

    public func endSkeleton() {
        for subview in subviews.compactMap({ $0 as? SkeletonView }) {
            subview.end()
            subview.removeFromSuperview()
        }
    }

    public func failedSkeleton() {
        for subview in subviews.compactMap({ $0 as? SkeletonView }) {
            subview.failed()
        }
    }

}
