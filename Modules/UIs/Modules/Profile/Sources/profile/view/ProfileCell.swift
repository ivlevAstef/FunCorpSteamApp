//
//  ProfileCell.swift
//  Profile
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import UIComponents
import SnapKit

private enum Consts {
    static let avatarSize: CGSize = CGSize(width: 76, height: 76)
}

final class ProfileCell: UITableViewCell
{
    static let preferredHeight: CGFloat = 96.0
    static let identifier = "\(ProfileCell.self)"

    private let avatarView = AvatarView(size: Consts.avatarSize.width)
    private let nickNameLabel = UILabel(frame: .zero)
    private let realNameLabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure(_ viewModel: CellViewModel<ProfileViewModel>, style: Design.Style) {
        // TODO: в идеале можно убедиться что style не менялся...
        relayout(use: style.layout)
        setStyle(style: style)

        switch viewModel {
        case .loading:
            contentView.subviews.forEach { $0.startSkeleton().apply(use: style) }
        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }
        case .done(let viewModel):
            nickNameLabel.endSkeleton()
            realNameLabel.endSkeleton()
            avatarView.setup(viewModel.avatar, letter: viewModel.avatarLetter, completion: { [weak avatarView] in
                avatarView?.endSkeleton()
            })

            nickNameLabel.text = viewModel.nick
            realNameLabel.text = viewModel.realName
        }
    }

    private func setStyle(style: Style) {
        avatarView.apply(use: style)

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
    }

    private func commonInit() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        realNameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(avatarView)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(realNameLabel)

        nickNameLabel.text = " "
        realNameLabel.text = " "
    }

    private func relayout(use layout: Style.Layout) {
        avatarView.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(12.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.size.equalTo(Consts.avatarSize)
        }

        nickNameLabel.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(12.0)
            maker.left.equalTo(avatarView.snp.right).offset(16.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }

        realNameLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(nickNameLabel.snp.bottom).offset(8.0)
            maker.left.equalTo(nickNameLabel.snp.left)
            maker.right.equalTo(nickNameLabel.snp.right)
        }
    }
}
