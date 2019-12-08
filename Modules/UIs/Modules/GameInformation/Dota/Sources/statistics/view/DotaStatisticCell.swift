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
    static let preferredHeight: CGFloat = 300.0
    static let identifier = "\(DotaStatisticCell.self)"

    private let segmentedControl = UISegmentedControl(frame: .zero)
    private let totalPrefixLabel = UILabel(frame: .zero)
    private let totalLabel = UILabel(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)
    private let graphic = DotaGraphicWithAxis()
    private let graphicHint = DotaGraphicHint()

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

        totalPrefixLabel.text = viewModel.totalPrefix

        contentView.subviews.forEach { stylizingSubviews.append($0.skeletonView) }
        switch viewModel.progressState {
        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }
        case .loading:
            contentView.subviews.forEach { $0.startSkeleton() }
        case .done:
            contentView.subviews.forEach { $0.endSkeleton() }

            segmentedControl.isUserInteractionEnabled = true
            let selectedIndex = viewModel.supportedIntervals.firstIndex(of: viewModel.state.selectedInterval) ?? 0
            segmentedControl.selectedSegmentIndex = selectedIndex

            updateIntervalSize()
        }
    }

    @objc
    private func changeSelection() {
        updateIntervalSize()
    }

    private func updateIntervalSize() {
        guard let viewModel = viewModel, !viewModel.state.groupedIndicators.isEmpty else {
            return
        }

        viewModel.updateInterval(on: viewModel.supportedIntervals[segmentedControl.selectedSegmentIndex])

        if let fromIndex = viewModel.state.fromIndex {
            graphic.configure(viewModel: viewModel)
            graphic.setOffset(fromIndex: fromIndex)

            graphic.updateFromIndexCallback = { [weak self] index in
                self?.updateIntervalOffsetIndex(fromIndex: index)
            }
            graphic.selectedCallback = { [weak self] indicator in
                self?.updateSelection(indicator: indicator)
            }

        }

        updateIntervalInformation()
    }

    private func updateSelection(indicator: DotaStatisticViewModel.Indicator?) {
        if let indicator = indicator, let viewModel = viewModel {
            graphicHint.configure(indicator: indicator,
                                  interval: viewModel.state.selectedInterval,
                                  names: viewModel.valueNames,
                                  colors: viewModel.valueColors)

            UIView.animate(withDuration: 0.15) {
                self.totalPrefixLabel.alpha = 0.0
                self.totalLabel.alpha = 0.0
                self.dateLabel.alpha = 0.0
                self.graphicHint.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                self.totalPrefixLabel.alpha = 1.0
                self.totalLabel.alpha = 1.0
                self.dateLabel.alpha = 1.0
                self.graphicHint.alpha = 0.0
            }
        }
    }

    private func updateIntervalOffsetIndex(fromIndex: Int) {
        guard let viewModel = viewModel, !viewModel.state.groupedIndicators.isEmpty else {
            return
        }
        if viewModel.state.fromIndex == fromIndex {
            return
        }

        viewModel.state.updateFromDate(use: fromIndex)

        updateIntervalInformation()
    }

    private func updateIntervalInformation() {
        guard let viewModel = viewModel, !viewModel.state.groupedIndicators.isEmpty else {
            totalLabel.text = "--"
            dateLabel.text = "--"
            return
        }

        let totalValues = viewModel.state.total
        totalLabel.text = totalValues.map { "\($0)" }.joined(separator: " / ")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"

        let fromText = dateFormatter.string(from: viewModel.state.from)
        let toText = dateFormatter.string(from: viewModel.state.to)
        dateLabel.text = "\(fromText) - \(toText)"
    }

    private func commonInit() {
        func addSubviewsOnContentView(_ subviews: [UIView]) {
            for subview in subviews {
                subview.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(subview)
            }
        }

        graphicHint.alpha = 0.0
        segmentedControl.addTarget(self, action: #selector(changeSelection), for: .valueChanged)

        addSubviewsOnContentView([
            segmentedControl,
            totalPrefixLabel,
            totalLabel,
            dateLabel,
            graphic,
            graphicHint
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

        totalPrefixLabel.numberOfLines = 1
        totalPrefixLabel.font = style.fonts.subtitle
        totalPrefixLabel.textColor = style.colors.contentText

        totalLabel.numberOfLines = 1
        totalLabel.font = style.fonts.title
        totalLabel.textColor = style.colors.mainText

        dateLabel.numberOfLines = 1
        dateLabel.font = style.fonts.subtitle
        dateLabel.textColor = style.colors.mainText

        graphic.apply(use: style)
        graphicHint.apply(use: style)

        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
        segmentedControl.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(6.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }

        totalPrefixLabel.setContentHuggingPriority(.required, for: .horizontal)
        totalPrefixLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        totalPrefixLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(segmentedControl.snp.bottom).offset(12.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.height.equalTo(totalPrefixLabel.font.lineHeight)
        }
        totalLabel.snp.remakeConstraints { maker in
            maker.lastBaseline.equalTo(totalPrefixLabel.snp.lastBaseline)
            maker.left.equalTo(totalPrefixLabel.snp.right).offset(4.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(totalLabel.font.lineHeight)
        }

        dateLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(totalPrefixLabel.snp.bottom).offset(6.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(dateLabel.font.lineHeight)
        }

        graphic.snp.remakeConstraints { maker in
            maker.top.equalTo(dateLabel.snp.bottom).offset(16.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(200.0)
        }

        graphicHint.snp.remakeConstraints { maker in
            maker.left.greaterThanOrEqualToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.lessThanOrEqualToSuperview().offset(-layout.cellInnerInsets.right)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(totalLabel.snp.top)
            maker.bottom.equalTo(dateLabel.snp.bottom).offset(12.0)
        }
    }
}
