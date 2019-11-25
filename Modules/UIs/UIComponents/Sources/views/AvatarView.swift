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

open class AvatarView: UIView {
    public var size: CGFloat {
        didSet { setNeedsLayout() }
    }

    public var cornerRadius: CGFloat = 0.0

    private var image: UIImage?
    private var unique: AvatarUnique?

    private var letter: String?
    private var style: Style?

    public init(size: CGFloat) {
        self.size = size
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))

        backgroundColor = .clear
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        let rect = CGRect(x: 0, y: 0, width: size, height: size)

        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        image?.draw(in: rect)
    }

    /// after call need call apply style
    public func setup(letter: String) {
        unique = nil
        self.letter = letter
        updateAvatarByLetterIfNeeded()
    }

    public func setup(_ newImage: UIImage?) {
        unique = nil
        letter = nil
        image = newImage
    }

    public func setup(_ newImage: ChangeableImage, letter: String? = nil, completion: (() -> Void)?) {
        let owner = AvatarUnique()
        unique = owner
        self.letter = letter
        newImage.weakJoin(listener: { [weak self] (_, newImage) in
            if nil != newImage {
                self?.letter = nil
            }
            self?.image = newImage
            self?.setNeedsDisplay()
            completion?()
        }, owner: owner)
        updateAvatarByLetterIfNeeded()
    }

    private func updateAvatarByLetterIfNeeded() {
        if let letter = self.letter, !letter.isEmpty, let style = self.style {
            let newImage = Self.generateAvatar(letter: letter, size: size, style: style)
            image = newImage
        }
    }
}

extension AvatarView: StylizingView
{
    public func apply(use style: Style) {
        self.style = style

        layer.shadowColor = style.colors.shadowColor.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.0
        layer.shadowOpacity = style.colors.shadowOpacity
        cornerRadius = 4.0

        updateAvatarByLetterIfNeeded()
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
