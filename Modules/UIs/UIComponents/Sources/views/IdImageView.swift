//
//  IdImageView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common

open class IdImageView: UIImageView
{
    fileprivate var owner: ChangeableImage?
    fileprivate var unique = AbstractImageUnique()
}

// MARK: - UIImageView
extension ChangeableImage {
    public func join(imageView: IdImageView, completion: (() -> Void)? = nil, file: String = #file, line: UInt = #line) {
        imageView.image = image
        imageView.owner = self

        imageView.unique = AbstractImageUnique()
        weakJoin(listener: { [weak self, weak imageView] (_, image) in
            if imageView?.owner === self {
                imageView?.image = image
                completion?()
            }
        }, owner: imageView.unique, file: file, line: line)
    }
}
