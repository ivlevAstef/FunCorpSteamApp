//
//  AvatarView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 28/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design

private class AvatarUnique {}

public final class AvatarView: IdImageView {
    public var size: CGFloat {
        didSet { setNeedsLayout() }
    }

    public var cornerRadius: CGFloat = 0.0

    private var unique: AvatarUnique?

    public init(size: CGFloat) {
        self.size = size
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))

        backgroundColor = .clear
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// after call need call apply style
    public func setup(letter: String) {
        unique = nil
    }

    public func setup(_ newImage: UIImage?) {
        unique = nil
        image = newImage
    }

    public func setup(_ newImage: ChangeableImage, completion: (() -> Void)? = nil) {
        let owner = AvatarUnique()
        unique = owner
        newImage.weakJoin(listener: { [weak self] (_, newImage) in
            self?.image = newImage
            completion?()
        }, owner: owner)
    }
}

extension AvatarView: StylizingView
{
    public func apply(use style: Style) {
        layer.shadowColor = style.colors.shadowColor.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.0
        layer.shadowOpacity = style.colors.shadowOpacity
    }
}

extension AvatarView
{
    public static func generateAvatar(letter: String, size: CGFloat, style: Style) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: size, height: size)).image { context in
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
            label.textAlignment = .center
            label.textColor = style.colors.mainText
            label.backgroundColor = style.colors.accent
            label.font = style.fonts.avatar.withSize(size * 0.5)
            label.text = letter

            label.layer.render(in: context.cgContext)
        }
    }
}
