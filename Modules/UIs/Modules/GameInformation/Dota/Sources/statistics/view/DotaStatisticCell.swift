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
    private let scrollGraphic = UIScrollView(frame: .zero)
    private let graphic = DotaGraphic()

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
        guard let viewModel = viewModel else {
            return
        }

        viewModel.updateInterval(on: viewModel.supportedIntervals[segmentedControl.selectedSegmentIndex])

        if let fromIndex = viewModel.state.fromIndex {
            let indicatorWidth = self.frame.width / CGFloat(viewModel.state.count)
            graphic.configure(indicators: viewModel.state.groupedIndicators, indicatorWidth: indicatorWidth)

            let offset = CGFloat(fromIndex) * indicatorWidth
            scrollGraphic.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
        }

        updateIntervalInformation()
    }

    private func updateIntervalOffset() {
        guard let viewModel = viewModel, !viewModel.state.groupedIndicators.isEmpty else {
            return
        }

        let offset = max(0, min(scrollGraphic.contentOffset.x, graphic.frame.width - scrollGraphic.frame.width))
        let index = Int(round(offset / graphic.indicatorWidth))

        viewModel.state.updateFromDate(use: index)

        updateIntervalInformation()
    }

    private func aroundContentOffset(to offset: CGFloat) -> CGFloat {
        guard let viewModel = viewModel, !viewModel.state.groupedIndicators.isEmpty else {
            return offset
        }

        return graphic.indicatorWidth * round(offset / graphic.indicatorWidth)
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

        scrollGraphic.addSubview(graphic)
        graphic.commonInit()

        scrollGraphic.isScrollEnabled = true
        scrollGraphic.showsHorizontalScrollIndicator = false
        scrollGraphic.showsVerticalScrollIndicator = false
        scrollGraphic.alwaysBounceHorizontal = true
        scrollGraphic.alwaysBounceVertical = false
        scrollGraphic.delegate = self

        segmentedControl.addTarget(self, action: #selector(changeSelection), for: .valueChanged)

        addSubviewsOnContentView([
            segmentedControl,
            totalPrefixLabel,
            totalLabel,
            dateLabel,
            scrollGraphic
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

        scrollGraphic.backgroundColor = style.colors.accent
        graphic.apply(use: style)

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

        scrollGraphic.snp.remakeConstraints { maker in
            maker.top.equalTo(dateLabel.snp.bottom).offset(8.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(200.0)
        }
    }
}

extension DotaStatisticCell: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateIntervalOffset()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var offset = targetContentOffset.pointee
        offset.x = aroundContentOffset(to: offset.x)
        targetContentOffset.pointee = offset
    }
}
