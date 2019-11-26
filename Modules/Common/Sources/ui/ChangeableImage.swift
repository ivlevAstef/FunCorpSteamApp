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

    /// Позволяет отложить загрузку картинки до момента, когда кто-то решит подписаться на ее изменения.
    public var fetcher: (() -> Void)?
    private var isFetching: Bool = false

    private var placeholder: UIImage?
    private var currentImage: UIImage?

    public init(placeholder: UIImage? = nil, image: UIImage? = nil) {
        self.placeholder = placeholder
        self.currentImage = image
    }

    public func updatePlaceholder(_ newPlaceholder: UIImage?) {
        DispatchQueue.mainSync {
            placeholder = newPlaceholder
            changeImageNotifier.notify(image)
        }
    }

    public func updateImage(_ newImage: UIImage?) {
        DispatchQueue.mainSync {
            currentImage = newImage
            changeImageNotifier.notify(image)
            isFetching = false
        }
    }

    public func join(
        listener: @escaping (UIImage?) -> Void,
        file: String = #file, line: UInt = #line) {
        runFetching()
        changeImageNotifier.join(listener: listener, file: file, line: line)
    }

    public func weakJoin<Owner: AnyObject>(
        listener: @escaping (Owner, UIImage?) -> Void,
        owner: Owner,
        file: String = #file, line: UInt = #line) {
        runFetching()
        changeImageNotifier.weakJoin(listener: listener, owner: owner, file: file, line: line)
    }

    private func runFetching() {
        DispatchQueue.mainSync {
            isFetching = true
            if currentImage === placeholder || nil == currentImage {
                fetcher?()
            }
        }
    }
}

// MARK: - UIImageView
extension ChangeableImage {
    public func join(imageView: UIImageView, file: String = #file, line: UInt = #line) {
        runFetching()
        imageView.image = image
        join(listener: { [weak imageView] image in
            imageView?.image = image
        }, file: file, line: line)
    }

    public func join(imageView: UIImageView, owner: AnyObject, file: String = #file, line: UInt = #line) {
        runFetching()
        imageView.image = image
        weakJoin(listener: { [weak imageView] (_, image) in
            imageView?.image = image
        }, owner: owner, file: file, line: line)
    }
}
