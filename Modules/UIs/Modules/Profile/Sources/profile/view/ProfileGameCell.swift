//
//  ProfileGameCell.swift
//  Profile
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import SnapKit
import Design
import UIComponents

final class ProfileGameCell: UITableViewCell {
    static let preferredHeight: CGFloat = 60.0
    static let identifier = "\(ProfileGameCell.self)"

    private let iconImageView = IdImageView(image: nil)
    private let nameLabel = UILabel(frame: .zero)
    private let timeLabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: CellViewModel<ProfileGameInfoViewModel>, style: Design.Style) {
        // TODO: в идеале можно убедиться что style не менялся...
        relayout(use: style.layout)
        setStyle(style: style)

        switch viewModel {
        case .loading:
            contentView.subviews.forEach { $0.startSkeleton().apply(use: style) }
        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }
        case .done(let viewModel):
            nameLabel.endSkeleton()
            timeLabel.endSkeleton()
            
            viewModel.icon.join(imageView: iconImageView, completion: { [weak iconImageView] in
                iconImageView?.endSkeleton()
            })

            nameLabel.text = viewModel.name
            timeLabel.text = viewModel.playtimePrefix + viewModel.playtime.adaptiveString
        }


    }

    private func commonInit() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)

        nameLabel.text = " "
        timeLabel.text = " "
    }

    private func setStyle(style: Style) {
        nameLabel.font = style.fonts.title
        nameLabel.textColor = style.colors.mainText
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1

        timeLabel.font = style.fonts.subtitle
        timeLabel.textColor = style.colors.notAccentText
        timeLabel.numberOfLines = 1
    }

    private func relayout(use layout: Style.Layout) {
        iconImageView.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 50.0, height: 50.0))
            maker.top.equalToSuperview().offset(5.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
        }

        nameLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(iconImageView.snp.top)
            maker.left.equalTo(iconImageView.snp.right).offset(8.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }

        timeLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            maker.left.equalTo(iconImageView.snp.right).offset(8.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }
   }
}
