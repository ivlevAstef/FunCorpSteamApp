//
//  ConstImage.swift
//  Common
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

public final class ConstImage
{
    public let image: UIImage?

    public init(image: UIImage? = nil) {
        self.image = image
    }

    func apply(to imageView: UIImageView) {
        imageView.image = image
    }
}
