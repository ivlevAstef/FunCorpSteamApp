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

open class AvatarView: IdImageView {

    public init() {
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
