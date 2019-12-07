//
//  DotaStatisticCell.swift
//  Dota
//
//  Created by Alexander Ivlev on 07/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents
import AppUIComponents
import SnapKit

final class DotaStatisticCell: ApTableViewCell
{
    static let preferredHeight: CGFloat = 250.0
    static let identifier = "\(DotaStatisticCell.self)"

    private let segmentedControl = UISegmentedControl(frame: .zero)
    private let avgPrefixLabel = UILabel(frame: .zero)
    private let avgLabel = UILabel(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)

    private var currentSelectedIntervalIndex: Int = 0
    private var viewModel: DotaStatisticViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: DotaStatisticViewModel) {
        self.viewModel = viewModel

        segmentedControl.removeAllSegments()
        for (index, interval) in viewModel.supportedIntervals.enumerated() {
            segmentedControl.insertSegment(withTitle: interval.localize, at: index, animated: false)
        }
        segmentedControl.isUserInteractionEnabled = false

        avgPrefixLabel.text = viewModel.avgPrefix

        contentView.subviews.forEach { stylizingSubviews.append($0.skeletonView) }
        switch viewModel.state {
        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }
        case .loading:
            contentView.subviews.forEach { $0.startSkeleton() }
        case .done(let indicators):
            contentView.subviews.forEach { $0.endSkeleton() }
            segmentedControl.isUserInteractionEnabled = true
            currentSelectedIntervalIndex = min(currentSelectedIntervalIndex, viewModel.supportedIntervals.count)
            segmentedControl.selectedSegmentIndex = currentSelectedIntervalIndex

            updateInterval()
        }
    }

    @objc
    private func changeSelection() {
        currentSelectedIntervalIndex = segmentedControl.selectedSegmentIndex

        updateInterval()
    }

    private func updateInterval() {
        avgLabel.text = "100"
        dateLabel.text = "21 Ноября - 28 Ноября 2019 года"
    }

    private func commonInit() {
        func addSubviewsOnContentView(_ subviews: [UIView]) {
            for subview in subviews {
                subview.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(subview)
            }
        }

        segmentedControl.addTarget(self, action: #selector(changeSelection), for: .valueChanged)

        addSubviewsOnContentView([
            segmentedControl,
            avgPrefixLabel,
            avgLabel,
            dateLabel
        ])
    }

    override func apply(use style: Style) {
        super.apply(use: style)

        backgroundColor = style.colors.background

        segmentedControl.backgroundColor = style.colors.accent
        segmentedControl.tintColor = style.colors.separator

        segmentedControl.setTitleTextAttributes([
            .font : style.fonts.title,
            .foregroundColor: style.colors.mainText
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .font : style.fonts.title,
            .foregroundColor: style.colors.mainText
        ], for: .selected)
        segmentedControl.layer.cornerRadius = 8.0

        avgPrefixLabel.numberOfLines = 1
        avgPrefixLabel.font = style.fonts.subtitle
        avgPrefixLabel.textColor = style.colors.contentText

        avgLabel.numberOfLines = 1
        avgLabel.font = style.fonts.title
        avgLabel.textColor = style.colors.mainText

        dateLabel.numberOfLines = 1
        dateLabel.font = style.fonts.subtitle
        dateLabel.textColor = style.colors.mainText

        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
        segmentedControl.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(6.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }

        avgPrefixLabel.setContentHuggingPriority(.required, for: .horizontal)
        avgPrefixLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        avgPrefixLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(segmentedControl.snp.bottom).offset(12.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.height.equalTo(avgPrefixLabel.font.lineHeight)
        }
        avgLabel.snp.remakeConstraints { maker in
            maker.lastBaseline.equalTo(avgPrefixLabel.snp.lastBaseline)
            maker.left.equalTo(avgPrefixLabel.snp.right).offset(4.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(avgLabel.font.lineHeight)
        }

        dateLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(avgPrefixLabel.snp.bottom).offset(6.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(dateLabel.font.lineHeight)
        }
    }
}
