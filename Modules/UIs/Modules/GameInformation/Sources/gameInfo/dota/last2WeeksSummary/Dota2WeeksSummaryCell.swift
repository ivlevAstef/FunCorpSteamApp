//
//  DotaLast2WeeksSummaryCell.swift
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


final class DotaLast2WeeksSummaryCell: ApTableViewCell
{
    static let preferredHeight: CGFloat = 232.0 // TODO: вот тут можно уже и получше, но надо писать вычисляемое значение, а это долго.
    static let identifier = "\(DotaLast2WeeksSummaryCell.self)"

    private let gamesCountLabel = UILabel(frame: .zero)

    private var detailsSubviews: [UIView] = []
    // TODO: это все конечно стоило бы переделать - сделать как в последней игре, в виде двух label - и таких два label в отдельную вьюшку даже.
    private let winLoseLabel = UILabel(frame: .zero)
    private let avgKillsLabel = UILabel(frame: .zero)
    private let avgDeathsLabel = UILabel(frame: .zero)
    private let avgAssistsLabel = UILabel(frame: .zero)
    private let avgLastHitsLabel = UILabel(frame: .zero)
    private let avgDeniesLabel = UILabel(frame: .zero)
    private let avgGPMLabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: SkeletonViewModel<Dota2WeeksGamesCountViewModel>) {
        [gamesCountLabel].forEach { stylizingSubviews.append($0.skeletonView) }
        switch viewModel {
        case .loading:
            [gamesCountLabel].forEach { $0.startSkeleton() }
        case .failed:
            [gamesCountLabel].forEach { $0.failedSkeleton() }
        case .done(let viewModel):
            [gamesCountLabel].forEach { $0.endSkeleton() }
            gamesCountLabel.text = viewModel.prefix + "\(viewModel.count)"
        }
    }

    func configure(_ viewModel: SkeletonViewModel<Dota2WeeksDetailsViewModel>) {
        detailsSubviews.forEach { stylizingSubviews.append($0.skeletonView) }
        switch viewModel {
        case .loading:
            detailsSubviews.forEach { $0.startSkeleton() }
        case .failed:
            detailsSubviews.forEach { $0.failedSkeleton() }
        case .done(let viewModel):
            detailsSubviews.forEach { $0.endSkeleton() }

            winLoseLabel.text = viewModel.winPrefix + "\(viewModel.win)"
            avgKillsLabel.text = viewModel.avgKillsPrefix + "\(viewModel.avgKills)"
            avgDeathsLabel.text = viewModel.avgDeathsPrefix + "\(viewModel.avgDeaths)"
            avgAssistsLabel.text = viewModel.avgAssistsPrefix + "\(viewModel.avgAssists)"
            avgLastHitsLabel.text = viewModel.avgLastHitsPrefix + "\(viewModel.avgLastHits)"
            avgDeniesLabel.text = viewModel.avgDeniesPrefix + "\(viewModel.avgDenies)"
            avgGPMLabel.text = viewModel.avgGPMPrefix + "\(viewModel.avgGPM)"
        }
    }

    private func commonInit() {
        func addSubviewsOnContentView(_ subviews: [UIView]) {
            for subview in subviews {
                subview.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(subview)
            }
        }

        detailsSubviews = [
            winLoseLabel,
            avgKillsLabel,
            avgDeathsLabel,
            avgAssistsLabel,
            avgLastHitsLabel,
            avgDeniesLabel,
            avgGPMLabel
        ]

        addSubviewsOnContentView([
            gamesCountLabel
        ] + detailsSubviews)
    }



    override func apply(use style: Style) {
        super.apply(use: style)

        gamesCountLabel.applyTitleAndMain(use: style)

        winLoseLabel.applyTitleAndMain(use: style)
        avgKillsLabel.applyTitleAndMain(use: style)
        avgDeathsLabel.applyTitleAndMain(use: style)
        avgAssistsLabel.applyTitleAndMain(use: style)
        avgLastHitsLabel.applyTitleAndMain(use: style)
        avgDeniesLabel.applyTitleAndMain(use: style)
        avgGPMLabel.applyTitleAndMain(use: style)

        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
        gamesCountLabel.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(6.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(gamesCountLabel.font.lineHeight)
        }

        winLoseLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(gamesCountLabel.snp.bottom).offset(2.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(winLoseLabel.font.lineHeight)
        }

        avgKillsLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(winLoseLabel.snp.bottom).offset(12.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(avgKillsLabel.font.lineHeight)
        }
        avgDeathsLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(avgKillsLabel.snp.bottom).offset(2.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(avgDeathsLabel.font.lineHeight)
        }
        avgAssistsLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(avgDeathsLabel.snp.bottom).offset(2.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(avgAssistsLabel.font.lineHeight)
        }

        avgLastHitsLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(avgAssistsLabel.snp.bottom).offset(12.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(avgLastHitsLabel.font.lineHeight)
        }
        avgDeniesLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(avgLastHitsLabel.snp.bottom).offset(2.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(avgDeniesLabel.font.lineHeight)
        }

        avgGPMLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(avgDeniesLabel.snp.bottom).offset(12.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(avgGPMLabel.font.lineHeight)
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
}
