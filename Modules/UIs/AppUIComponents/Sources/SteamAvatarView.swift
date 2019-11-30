//
//  SteamAvatarView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import UIComponents
import Design
import SnapKit

public final class SteamAvatarView: UIView
{
    fileprivate let shadowView: UIView = UIView(frame: .zero)
    fileprivate let avatarView: AvatarView = AvatarView()

    private var shadowConstrant: Constraint?
    private var size: CGSize = .zero

    public init() {
        super.init(frame: .zero)

        addSubview(shadowView)
        addSubview(avatarView)
        avatarView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        shadowView.snp.makeConstraints { maker in
            shadowConstrant = maker.edges.equalToSuperview().constraint
        }

        clipsToBounds = false
        layer.masksToBounds = false
        shadowView.clipsToBounds = false
        shadowView.layer.masksToBounds = false
        
        avatarView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if size.equalTo(frame.size) {
            return
        }
        size = frame.size

        let r = size.width * 0.06

        let o = size.width * 0.02
        shadowConstrant?.update(inset: UIEdgeInsets(top: o, left: o, bottom: o, right: o))

        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = r
        shadowView.layer.cornerRadius = r
        avatarView.layer.cornerRadius = r
    }
}

extension ChangeableImage {
    public func join(imageView: SteamAvatarView, completion: (() -> Void)? = nil,
                     file: String = #file, line: UInt = #line) {
        join(imageView: imageView.avatarView, completion: completion, file: file, line: line)
    }
}

extension SteamAvatarView: StylizingView
{
    public func apply(use style: Style) {
        shadowView.backgroundColor = style.colors.shadowColor
        shadowView.layer.shadowColor = style.colors.shadowColor.cgColor
        shadowView.layer.shadowOpacity = style.colors.shadowOpacity
    }
}
