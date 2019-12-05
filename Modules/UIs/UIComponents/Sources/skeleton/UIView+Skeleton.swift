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
    public var skeletonView: SkeletonView {
        if let skeleton = subviews.compactMap({ $0 as? SkeletonView}).last {
            return skeleton
        }

        let skeleton = SkeletonView()
        addSubview(skeleton)

        skeleton.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        return skeleton
    }

    public func startSkeleton() {
        let skeletonViews = subviews.compactMap { $0 as? SkeletonView }
        UIView.animate(withDuration: 0.15, animations: {
            for subview in skeletonViews {
                subview.start()
            }
        })
    }

    public func endSkeleton() {
        let skeletonViews = subviews.compactMap { $0 as? SkeletonView }
        UIView.animate(withDuration: 0.15, animations: {
            for subview in skeletonViews {
                subview.end()
            }
        })
    }

    public func failedSkeleton() {
        let skeletonViews = subviews.compactMap { $0 as? SkeletonView }
        UIView.animate(withDuration: 0.25, animations: {
            for subview in skeletonViews {
                subview.failed()
            }
        })
    }

    public func endSkeleton(success: Bool) {
        if success {
            endSkeleton()
        } else {
            failedSkeleton()
        }
    }

}
