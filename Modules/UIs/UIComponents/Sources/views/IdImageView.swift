//
//  IdImageView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common

public final class IdImageView: UIImageView
{
    fileprivate var owner: ChangeableImage?
}

// MARK: - UIImageView
extension ChangeableImage {
    public func join(imageView: IdImageView, file: String = #file, line: UInt = #line) {
        imageView.image = image
        imageView.owner = self

        join(listener: { [weak self, weak imageView] image in
            if imageView?.owner === self {
                imageView?.image = image
            }
        }, file: file, line: line)
    }

    public func join(imageView: IdImageView, owner: AnyObject, file: String = #file, line: UInt = #line) {
        imageView.image = image
        imageView.owner = self

        weakJoin(listener: { [weak self, weak imageView] (_, image) in
            if imageView?.owner === self {
                imageView?.image = image
            }
        }, owner: owner, file: file, line: line)
    }
}
