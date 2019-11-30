//
//  FriendCell.swift
//  Profile
//
//  Created by Alexander Ivlev on 30/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents
import AppUIComponents
import SnapKit

private enum Consts {
    static let avatarSize: CGFloat = 40.0
}

final class FriendCell: ApTableViewCell
{
    static let preferredHeight: CGFloat = 52.0
    static let identifier = "\(FriendCell.self)"

    private(set) var visibleViewModel: FriendViewModel?

    private let avatarView = SteamAvatarView()
    private let nickNameLabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: FriendViewModel) {
        self.visibleViewModel = viewModel

        switch viewModel.state {
        case .loading:
            contentView.subviews.forEach { stylizingSubviews.append($0.startSkeleton()) }

        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }

        case .done(let content):
            nickNameLabel.endSkeleton()

            content.avatar.join(imageView: avatarView, completion: { [weak avatarView] in
                avatarView?.endSkeleton()
            })

            nickNameLabel.text = content.nick
        }

        // При появлении ячейки, всегда посылаем запрос на появление - дабы если, что обновить данные
        viewModel.needUpdateCallback?()
    }

    private func commonInit() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(avatarView)
        contentView.addSubview(nickNameLabel)

        nickNameLabel.text = " "
    }

    override func apply(use style: Style) {
        super.apply(use: style)

        avatarView.backgroundColor = style.colors.accent
        avatarView.apply(use: style)

        nickNameLabel.font = style.fonts.large
        nickNameLabel.textColor = style.colors.mainText
        nickNameLabel.minimumScaleFactor = 0.8
        nickNameLabel.numberOfLines = 1
        nickNameLabel.lineBreakMode = .byTruncatingTail

        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
        avatarView.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(6.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.size.equalTo(CGSize(width: Consts.avatarSize, height: Consts.avatarSize))
        }

        nickNameLabel.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(6.0)
            maker.left.equalTo(avatarView.snp.right).offset(16.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }
    }
}
