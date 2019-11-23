//
//  ProfileTopView.swift
//  Profile
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import SnapKit

private enum Consts {
    static let avatarSize: CGSize = CGSize(width: 92, height: 92)
}

final class ProfileTopView: UIView
{
    private let avatarView = UIImageView(image: nil)
    private let nickNameLabel = UILabel(frame: .zero)
    private let realNameLabel = UILabel(frame: .zero)
    private let separatorView = UIView(frame: .zero)

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(profile: ProfileViewModel) {
        profile.avatar.join(imageView: avatarView)
        nickNameLabel.text = profile.nick
        realNameLabel.text = profile.realName
    }

    private func commonInit() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        realNameLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarView)
        addSubview(nickNameLabel)
        addSubview(realNameLabel)
        addSubview(separatorView)

        nickNameLabel.text = " "
        realNameLabel.text = " "
    }

    private func relayout(use layout: Style.Layout) {
        avatarView.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(layout.innerInsets.top)
            maker.left.equalToSuperview().offset(layout.innerInsets.left)
            maker.size.equalTo(Consts.avatarSize)
            maker.bottom.equalToSuperview().offset(-16.0)
        }

        nickNameLabel.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(layout.innerInsets.top)
            maker.left.equalTo(avatarView.snp.right).offset(16.0)
            maker.right.equalToSuperview().offset(-layout.innerInsets.right)
        }

        realNameLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(nickNameLabel.snp.bottom).offset(8.0)
            maker.left.equalTo(nickNameLabel.snp.left)
            maker.right.equalTo(nickNameLabel.snp.right)
        }

        separatorView.snp.remakeConstraints { maker in
            maker.height.equalTo(1.0)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
}

extension ProfileTopView: StylizingView
{
    func apply(use style: Style) {
        avatarView.layer.borderColor = style.colors.accent.cgColor
        avatarView.layer.borderWidth = 2.0

        nickNameLabel.font = style.fonts.large
        nickNameLabel.textColor = style.colors.mainText
        nickNameLabel.minimumScaleFactor = 0.5
        nickNameLabel.numberOfLines = 1
        nickNameLabel.lineBreakMode = .byTruncatingTail

        realNameLabel.font = style.fonts.large
        realNameLabel.textColor = style.colors.mainText
        realNameLabel.minimumScaleFactor = 0.5
        realNameLabel.numberOfLines = 1
        realNameLabel.lineBreakMode = .byTruncatingTail

        separatorView.backgroundColor = style.colors.separator

        relayout(use: style.layout)
    }
}
