//
//  DotaGraphic.swift
//  Dota
//
//  Created by Alexander Ivlev on 07/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import SnapKit
import UIComponents

final class DotaGraphic: ApCollectionView
{
    var updateFromIndexCallback: ((Int) -> Void)?

    private var indicators: [DotaStatisticViewModel.Indicator] = []
    private var barColors: [UIColor] = []
    private var barNames: [String] = []
    private var interval: DotaStatisticViewModel.Interval = .day

    private let flowLayout = UICollectionViewFlowLayout()

    private var indicatorWidth: CGFloat = 0.0
    private var visibleMaxSum: Int = 0

    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: DotaStatisticViewModel, width: CGFloat) {
        indicatorWidth = width / CGFloat(viewModel.state.count)

        self.indicators = viewModel.state.groupedIndicators
        self.interval = viewModel.state.selectedInterval
        self.barColors = viewModel.valueColors
        self.barNames = viewModel.valueNames

        visibleMaxSum = 0
        flowLayout.invalidateLayout()
        reloadData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if 0 == visibleMaxSum {
            recalculateVisibleMaxSum()
            reconfigureVisibleCells(animated: false)
        }
    }

    func setOffset(fromIndex: Int) {
        if 0 <= fromIndex && fromIndex < indicators.count {
            scrollToItem(at: IndexPath(item: fromIndex, section: 0), at: .left, animated: false)

            recalculateVisibleMaxSum()
            reconfigureVisibleCells()
        } else {
            log.assert("incorrect from index")
        }
    }

    private func commonInit() {
        register(BarCell.self, forCellWithReuseIdentifier: BarCell.identifier)
        delegate = self
        dataSource = self

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10.0
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    private func recalculateVisibleMaxSum() {
        var newVisibleMaxSum: Int = 0

        for index in indexPathsForVisibleItems.map({ $0.item }) {
            let maxSum = indicators[index].values.reduce(0, +)
            if maxSum > newVisibleMaxSum {
                newVisibleMaxSum = maxSum
            }
        }
        visibleMaxSum = newVisibleMaxSum
    }

    private func reconfigureVisibleCells(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.reconfigureVisibleCells(animated: false)
            }
        } else {
            for barCell in visibleCells.compactMap({ $0 as? BarCell }) {
                barCell.reconfigure(colors: barColors, visibleMaxSum: visibleMaxSum)
            }
        }
    }

    override func apply(use style: Style) {
        super.apply(use: style)
    }

}

extension DotaGraphic: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index = indexPathsForVisibleItems.min()?.item {
            updateFromIndexCallback?(index)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            recalculateVisibleMaxSum()
            reconfigureVisibleCells()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        recalculateVisibleMaxSum()
        reconfigureVisibleCells()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indicators.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: indicatorWidth, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: BarCell.identifier, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let barCell = cell as? BarCell {
            barCell.contentView.frame.size = CGSize(width: indicatorWidth, height: collectionView.frame.height)
            barCell.configure(indicator: indicators[indexPath.row],
                              interval: interval,
                              colors: barColors,
                              visibleMaxSum: visibleMaxSum)

            addViewForStylizing(barCell)
        }
    }
}

private class BarCell: UICollectionViewCell, StylizingView
{
    static let identifier: String = "\(BarCell.self)"
    private var prevVisibleMaxSum: Int = 0
    private var indicator: DotaStatisticViewModel.Indicator?

    private lazy var barView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }()

    private lazy var dateLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }()

    private lazy var barCornerView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = true
        barView.addSubview(view)
        return view
    }()

    func reconfigure(colors: [UIColor], visibleMaxSum: Int) {
        if prevVisibleMaxSum == visibleMaxSum || visibleMaxSum == 0 {
            return
        }

        if let indicator = indicator {
            prevVisibleMaxSum = visibleMaxSum

            makeSubviews(count: indicator.values.count)
            configureBars(indicator, colors: colors, visibleMaxSum: visibleMaxSum)
        }
    }

    func configure(indicator: DotaStatisticViewModel.Indicator,
                   interval: DotaStatisticViewModel.Interval,
                   colors: [UIColor],
                   visibleMaxSum: Int) {
        log.assert(indicator.values.count == colors.count, "invalid values count")
        self.indicator = indicator
        self.prevVisibleMaxSum = visibleMaxSum

        configureDateLabel(date: indicator.date, interval: interval)

        configureBarView()

        if visibleMaxSum == 0 {
            barCornerView.subviews.forEach { $0.removeFromSuperview() }
            return
        }

        makeSubviews(count: indicator.values.count)
        configureBars(indicator, colors: colors, visibleMaxSum: visibleMaxSum)
    }

    func apply(use style: Style) {
        dateLabel.numberOfLines = 2
        dateLabel.font = style.fonts.content
        dateLabel.textColor = style.colors.mainText
        dateLabel.textAlignment = .center
    }

    private func configureDateLabel(date: Date, interval: DotaStatisticViewModel.Interval) {
        dateLabel.frame.size = CGSize(width: contentView.frame.width, height: 35.0)
        dateLabel.frame.origin = CGPoint(x: 0, y: contentView.frame.height - dateLabel.frame.size.height)

        let dateFormatter = DateFormatter()
        switch interval {
        case .indicator:
            dateFormatter.dateFormat = "HH:mm\ndd.MM"
        case .day:
            dateFormatter.dateFormat = "dd.MM\nyyyy"
        case .week:
            dateFormatter.dateFormat = "ww\nyyyy"
        case .month:
            dateFormatter.dateFormat = "LLL\nyyyy"
        }
        dateLabel.text = dateFormatter.string(from: date)
    }

    private func configureBars(_ indicator: DotaStatisticViewModel.Indicator, colors: [UIColor], visibleMaxSum: Int) {
        for (view, color) in zip(barCornerView.subviews, colors) {
            view.backgroundColor = color
            view.frame.origin = CGPoint(x: 0, y: barView.frame.height)
            view.frame.size = CGSize(width: barView.frame.width, height: 0)
        }

        let fullyProcent = CGFloat(indicator.values.reduce(0, +)) / CGFloat(visibleMaxSum)
        let fullyHeight = barView.frame.height * fullyProcent

        var offset: CGFloat = fullyHeight
        for (value, view) in zip(indicator.values, barCornerView.subviews) {
            let procentHeight = CGFloat(value) / CGFloat(visibleMaxSum)

            view.frame.size.height = barView.frame.height * procentHeight
            offset -= view.frame.height

            view.frame.origin.y = offset
        }


        let radii = barView.frame.width * 0.1
        barCornerView.frame = CGRect(x: 0,
                                     y: barView.frame.height - fullyHeight,
                                     width: barView.frame.width,
                                     height: fullyHeight + radii)
        // + radii чтобы не обрезалось снизу. Маска через BezierPath не канает - она не анимируется нормально

        barCornerView.layer.cornerRadius = radii
    }

    private func configureBarView() {
        barView.frame.origin = .zero
        barView.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.height - dateLabel.frame.height)
    }

    private func makeSubviews(count: Int) {
        while barCornerView.subviews.count < count {
            let view = UIView(frame: .zero)
            barCornerView.addSubview(view)
        }
        while barCornerView.subviews.count > count {
            barCornerView.subviews.last?.removeFromSuperview()
        }
    }
}
