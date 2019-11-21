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

    public init(named name: String) {
        self.image = UIImage(named: name)
        log.assert(self.image != nil, "Can't initialize image by name: \(name)")
    }

    func apply(to imageView: UIImageView) {
        imageView.image = image
    }
}
