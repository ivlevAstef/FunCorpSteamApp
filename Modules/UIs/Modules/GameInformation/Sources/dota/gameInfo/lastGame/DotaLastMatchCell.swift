//
//  DotaLastMatchCell.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 05/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents
import AppUIComponents
import SnapKit

private enum Consts {
    static let avatarSize = CGSize(width: 78, height: 90)

    static let imageOffset: CGFloat = 6.0
    static let lineSpacing: CGFloat = 6.0
}

final class DotaLastMatchCell: ApTableViewCell
{
    static let preferredHeight: CGFloat = 102.0
    static let identifier = "\(DotaLastMatchCell.self)"

    private let heroAvatarView = SteamAvatarView()
    private let heroNameLabel = UILabel(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)

    private let kdaTextLabel = UILabel(frame: .zero)
    private let kdaStatsLabel = UILabel(frame: .zero)

    private let durationTextLabel = UILabel(frame: .zero)
    private let durationStatsLabel = UILabel(frame: .zero)

    private let resultTextLabel = UILabel(frame: .zero)
    private let resultStatsLabel = UILabel(frame: .zero)

    private var subviewsWithOutAvatarView: [UIView] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: SkeletonViewModel<DotaLastMatchViewModel>) {
        contentView.subviews.forEach { stylizingSubviews.append($0.skeletonView) }
        switch viewModel {
        case .loading:
            contentView.subviews.forEach { $0.startSkeleton() }
        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }
        case .done(let viewModel):
            subviewsWithOutAvatarView.forEach { $0.endSkeleton() }

            viewModel.heroImage.join(imageView: heroAvatarView, completion: { [weak heroAvatarView] in
                heroAvatarView?.endSkeleton(success: nil != heroAvatarView?.image)
            })

            heroNameLabel.text = viewModel.heroName

            kdaTextLabel.text = viewModel.kdaText
            kdaStatsLabel.text = "\(viewModel.kills) / \(viewModel.deaths) / \(viewModel.assists)"

            durationTextLabel.text = viewModel.durationText
            durationStatsLabel.text = viewModel.duration.detailsAdaptiveString

            resultTextLabel.text = viewModel.resultText
            if viewModel.isWin {
                resultStatsLabel.text = viewModel.winText
                resultStatsLabel.textColor = .green
            } else {
                resultStatsLabel.text = viewModel.loseText
                resultStatsLabel.textColor = .red
            }

            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
            dateLabel.text = dateFormat.string(from: viewModel.startTime)
        }
    }

    private func commonInit() {
        func addSubviewsOnContentView(_ subviews: [UIView]) {
            for subview in subviews {
                subview.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(subview)
            }
        }

        subviewsWithOutAvatarView = [
            heroNameLabel,
            kdaTextLabel,
            kdaStatsLabel,
            durationTextLabel,
            durationStatsLabel,
            resultTextLabel,
            resultStatsLabel,
            dateLabel
        ]

        addSubviewsOnContentView([
            heroAvatarView
        ] + subviewsWithOutAvatarView)
    }



    override func apply(use style: Style) {
        super.apply(use: style)

        heroAvatarView.apply(use: style)
        heroNameLabel.applyTitleAndMain(use: style)
        kdaTextLabel.applySubtitleAndContent(use: style)
        kdaStatsLabel.applyTitleAndMain(use: style)
        durationTextLabel.applySubtitleAndContent(use: style)
        durationStatsLabel.applyTitleAndMain(use: style)
        resultTextLabel.applySubtitleAndContent(use: style)

        resultStatsLabel.numberOfLines = 1
        resultStatsLabel.textAlignment = .left
        resultStatsLabel.font = style.fonts.title

        dateLabel.applyDate(use: style)

        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
        heroAvatarView.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(6.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.size.equalTo(Consts.avatarSize)
        }

        heroNameLabel.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(6.0)
            maker.left.equalTo(heroAvatarView.snp.right).offset(Consts.imageOffset)
            maker.height.equalTo(heroNameLabel.font.lineHeight)
        }
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        dateLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(heroNameLabel.snp.top)
            maker.left.equalTo(heroNameLabel.snp.right).offset(4.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(dateLabel.font.lineHeight)
        }

        kdaTextLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(heroNameLabel.snp.bottom).offset(Consts.lineSpacing)
            maker.left.equalTo(heroNameLabel.snp.left)
            maker.height.equalTo(kdaTextLabel.font.lineHeight)
        }
        kdaStatsLabel.setContentHuggingPriority(.required, for: .horizontal)
        kdaStatsLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        kdaStatsLabel.snp.remakeConstraints { maker in
            maker.lastBaseline.equalTo(kdaTextLabel.snp.lastBaseline)
            maker.left.equalTo(kdaTextLabel.snp.right).offset(4.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(kdaStatsLabel.font.lineHeight)
        }

        durationTextLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(kdaTextLabel.snp.bottom).offset(Consts.lineSpacing)
            maker.left.equalTo(kdaTextLabel.snp.left)
            maker.height.equalTo(durationTextLabel.font.lineHeight)
        }
        durationStatsLabel.setContentHuggingPriority(.required, for: .horizontal)
        durationStatsLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        durationStatsLabel.snp.remakeConstraints { maker in
            maker.lastBaseline.equalTo(durationTextLabel.snp.lastBaseline)
            maker.left.equalTo(durationTextLabel.snp.right).offset(4.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(durationStatsLabel.font.lineHeight)
        }

        resultTextLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(durationTextLabel.snp.bottom).offset(Consts.lineSpacing)
            maker.left.equalTo(durationTextLabel.snp.left)
            maker.height.equalTo(resultTextLabel.font.lineHeight)
        }
        resultStatsLabel.setContentHuggingPriority(.required, for: .horizontal)
        resultStatsLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        resultStatsLabel.snp.remakeConstraints { maker in
            maker.lastBaseline.equalTo(resultTextLabel.snp.lastBaseline)
            maker.left.equalTo(resultTextLabel.snp.right).offset(4.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(resultStatsLabel.font.lineHeight)
        }
    }
}

private extension UILabel {
    func applyTitleAndMain(use style: Style) {
        numberOfLines = 1
        textAlignment = .left
        font = style.fonts.title
        textColor = style.colors.mainText
    }

    func applySubtitleAndContent(use style: Style) {
        numberOfLines = 1
        textAlignment = .left
        font = style.fonts.subtitle
        textColor = style.colors.contentText
    }

    func applyDate(use style: Style) {
        numberOfLines = 1
        textAlignment = .right
        font = style.fonts.subtitle
        textColor = style.colors.contentText
    }
}
