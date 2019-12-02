//
//  AchievementsSummaryCell.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents
import AppUIComponents
import SnapKit

final class AchievementsSummaryCell: ApTableViewCell
{
    static let preferredHeight: CGFloat = 40.0
    static let identifier = "\(AchievementsSummaryCell.self)"

    private let summaryLabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: SkeletonViewModel<AchievementsSummaryViewModel?>) {
        contentView.subviews.forEach { stylizingSubviews.append($0.skeletonView) }
        switch viewModel {
        case .loading:
            contentView.subviews.forEach { $0.startSkeleton() }
        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }
        case .done(let viewModel):
            contentView.subviews.forEach { $0.endSkeleton() }
            // TODO: в идеале конечно замапить в таблице, но лень
            log.assert(nil != viewModel, "Achievements summary view model can't be nil into cell")
            if let viewModel = viewModel {
                summaryLabel.text = "\(viewModel.prefix) \(viewModel.current) / \(viewModel.any)"
            }
        }
    }

    private func commonInit() {
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(summaryLabel)

        summaryLabel.text = " "
    }

    override func apply(use style: Style) {
        super.apply(use: style)

        summaryLabel.font = style.fonts.title
        summaryLabel.textColor = style.colors.mainText
        summaryLabel.numberOfLines = 1


        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
        summaryLabel.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(8.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }
    }
}
