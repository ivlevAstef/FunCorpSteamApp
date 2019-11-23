//
//  ChangeableImage.swift
//  Common
//
//  Created by Alexander Ivlev on 29/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

public final class ChangeableImage
{
    private let changeImageNotifier = Notifier<UIImage?>()

    public var image: UIImage? {
        return self.currentImage ?? self.placeholder
    }

    private let placeholder: UIImage?
    private var currentImage: UIImage?

    public init(placeholder: UIImage? = nil, image: UIImage? = nil) {
        self.placeholder = placeholder
        self.currentImage = image
    }

    public func updateImage(image newImage: UIImage?) {
        DispatchQueue.mainSync {
            currentImage = newImage
            changeImageNotifier.notify(image)
        }
    }

    public func join(
        listener: @escaping (UIImage?) -> Void,
        file: String = #file, line: UInt = #line) {
        changeImageNotifier.join(listener: listener, file: file, line: line)
    }

    public func weakJoin<Owner: AnyObject>(
        listener: @escaping (Owner, UIImage?) -> Void,
        owner: Owner,
        file: String = #file, line: UInt = #line) {
        changeImageNotifier.weakJoin(listener: listener, owner: owner, file: file, line: line)
    }
}

// MARK: - UIImageView
extension ChangeableImage {
    public func join(imageView: UIImageView, file: String = #file, line: UInt = #line) {
        imageView.image = image
        join(listener: { [weak imageView] image in
            imageView?.image = image
        }, file: file, line: line)
    }

    public func join(imageView: UIImageView, owner: AnyObject, file: String = #file, line: UInt = #line) {
        imageView.image = image
        weakJoin(listener: { [weak imageView] (_, image) in
            imageView?.image = image
        }, owner: owner, file: file, line: line)
    }
}
