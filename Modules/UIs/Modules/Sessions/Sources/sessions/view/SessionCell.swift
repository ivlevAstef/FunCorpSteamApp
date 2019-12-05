//
//  SessionCell.swift
//  Sessions
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import SnapKit
import Design
import UIComponents
import AppUIComponents

private enum Consts {
    static let iconSize: CGFloat = 44.0
}

final class SessionCell: ApTableViewCell {
    static let preferredHeight: CGFloat = 72.0
    static let identifier = "\(SessionCell.self)"

    private let iconImageView = SteamGameImageView(image: nil)
    private let nameLabel = UILabel(frame: .zero)
    private let timeForeverLabel = UILabel(frame: .zero)
    private let time2weeksLabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: SkeletonViewModel<SessionViewModel>) {
        contentView.subviews.forEach { stylizingSubviews.append($0.skeletonView) }
        switch viewModel {
        case .loading:
            contentView.subviews.forEach { $0.startSkeleton() }
        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }
        case .done(let viewModel):
            nameLabel.endSkeleton()
            timeForeverLabel.endSkeleton()
            time2weeksLabel.endSkeleton()

            viewModel.icon.join(imageView: iconImageView, completion: { [weak iconImageView] in
                iconImageView?.endSkeleton(success: nil != iconImageView?.image)
            })

            nameLabel.text = viewModel.name
            timeForeverLabel.text = viewModel.playtimeForeverPrefix + viewModel.playtimeForever.adaptiveString
            time2weeksLabel.text = viewModel.playtime2weeksPrefix +
                viewModel.playtime2weeks.adaptiveString +
                viewModel.playtime2weeksSuffix
        }
    }

    private func commonInit() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeForeverLabel.translatesAutoresizingMaskIntoConstraints = false
        time2weeksLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeForeverLabel)
        contentView.addSubview(time2weeksLabel)
    }

    override func apply(use style: Style) {
        super.apply(use: style)

        iconImageView.apply(use: style, size: Consts.iconSize)

        nameLabel.font = style.fonts.title
        nameLabel.textColor = style.colors.mainText
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1

        timeForeverLabel.font = style.fonts.subtitle
        timeForeverLabel.textColor = style.colors.notAccentText
        timeForeverLabel.numberOfLines = 1

        time2weeksLabel.font = style.fonts.subtitle
        time2weeksLabel.textColor = style.colors.notAccentText
        time2weeksLabel.numberOfLines = 1

        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
        iconImageView.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: Consts.iconSize, height: Consts.iconSize))
            maker.top.equalToSuperview().offset(5.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
        }

        nameLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(iconImageView.snp.top)
            maker.left.equalTo(iconImageView.snp.right).offset(8.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(nameLabel.font.lineHeight)
        }

        timeForeverLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            maker.left.equalTo(iconImageView.snp.right).offset(8.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(timeForeverLabel.font.lineHeight)
        }

        time2weeksLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(timeForeverLabel.snp.bottom).offset(2.0)
            maker.left.equalTo(timeForeverLabel.snp.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(time2weeksLabel.font.lineHeight)
        }
    }
}
