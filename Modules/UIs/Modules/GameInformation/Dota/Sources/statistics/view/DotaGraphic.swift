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

final class DotaGraphicWithAxis: UIView, StylizingView
{
    var updateFromIndexCallback: ((Int) -> Void)? {
        set { graphic.updateFromIndexCallback = newValue }
        get { graphic.updateFromIndexCallback }
    }

    var selectedCallback: ((DotaStatisticViewModel.Indicator?) -> Void)?

    private let graphic: DotaGraphic = DotaGraphic()
    private let separator: UIView = UIView(frame: .zero)
    private let maxLabel: UILabel = UILabel(frame: .zero)

    private var prevSize: CGSize = .zero
    private var indicatorsCountOnScreen: Int = 1
    private var barNames: [String] = []
    private var fromIndex: Int? = nil

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: DotaStatisticViewModel) {
        self.indicatorsCountOnScreen = viewModel.state.count
        self.barNames = viewModel.valueNames
        self.prevSize = .zero
        graphic.indicatorWidth = 0.0

        graphic.updateVisibleMaxSumCallback = { [weak self] sum in
            self?.updateVisibleMaxSum(to: sum)
        }

        graphic.configure(viewModel: viewModel)

        setNeedsLayout()
    }

    func setOffset(fromIndex: Int) {
        self.fromIndex = fromIndex
        setNeedsLayout()
    }

    private func updateVisibleMaxSum(to sum: Int) {
        if 0 == sum {
            maxLabel.isHidden = true
        } else {
            maxLabel.text = "\(sum)"
            maxLabel.isHidden = false
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Тут конечно слегка жесть, но что поделаешь, если надо быстро, но чтобы все нормально работало на разных системах.

        if frame.size.equalTo(prevSize) {
            return
        }
        prevSize = frame.size
        // -1 не нужен, дабы осталось чуть места
        let spacings = CGFloat(indicatorsCountOnScreen) * DotaGraphic.itemSpacing
        let indicatorWidth = (frame.width - spacings) / CGFloat(indicatorsCountOnScreen)
        if graphic.indicatorWidth != indicatorWidth {
            graphic.indicatorWidth = indicatorWidth

            graphic.invalidateLayout()
            graphic.reloadData()
            graphic.setNeedsLayout()
            graphic.layoutIfNeeded()
        }

        if let fromIndex = self.fromIndex {
            graphic.setOffset(fromIndex: fromIndex)
            self.fromIndex = nil

            graphic.setNeedsLayout()
            graphic.layoutIfNeeded()
        }

        graphic.recalculateVisibleMaxSum()
        graphic.reconfigureVisibleCells(animated: false)
    }

    func apply(use style: Style) {
        graphic.apply(use: style)

        maxLabel.font = style.fonts.content
        maxLabel.textColor = style.colors.notAccentText

        separator.backgroundColor = style.colors.separator
    }

    private func commonInit() {
        addSubview(graphic)
        addSubview(maxLabel)
        addSubview(separator)

        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onPress(_:)))
        gestureRecognizer.minimumPressDuration = 0.08
        addGestureRecognizer(gestureRecognizer)
        graphic.didScrollCallback = { [weak self] in
            self?.select(indicator: nil, index: nil)
        }

        maxLabel.isHidden = true
        isUserInteractionEnabled = true

        graphic.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        separator.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(1)
        }

        maxLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.right.equalToSuperview()
        }
    }

    @objc
    private func onPress(_ recognizer: UILongPressGestureRecognizer) {
        guard let (indicator, index) = graphic.indicatorWithIndexForItem(at: recognizer.location(in: graphic)) else {
            return
        }

        select(indicator: indicator, index: index)
    }

    private func select(indicator: DotaStatisticViewModel.Indicator?, index: Int?) {
        selectedCallback?(indicator)
        graphic.selectedIndex = index
    }
}

private final class DotaGraphic: ApCollectionView
{
    static let itemSpacing: CGFloat = 4.0

    var updateFromIndexCallback: ((Int) -> Void)?

    fileprivate var updateVisibleMaxSumCallback: ((Int) -> Void)?
    fileprivate var didScrollCallback: (() -> Void)?


    fileprivate var indicatorWidth: CGFloat = 0.0
    fileprivate var selectedIndex: Int? {
        didSet {
            if oldValue != selectedIndex {
                reconfigureVisibleCells()
            }
        }
    }

    private var indicators: [DotaStatisticViewModel.Indicator] = []
    private var barColors: [UIColor] = []
    private var interval: DotaStatisticViewModel.Interval = .day

    private let flowLayout = UICollectionViewFlowLayout()

    private var visibleMaxSum: Int = 0 {
        didSet {
            updateVisibleMaxSumCallback?(visibleMaxSum)
        }
    }

    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: DotaStatisticViewModel) {
        self.indicators = viewModel.state.groupedIndicators
        self.interval = viewModel.state.selectedInterval
        self.barColors = viewModel.valueColors
        self.visibleMaxSum = 0
    }

    func setOffset(fromIndex: Int) {
        if 0 <= fromIndex && fromIndex < indicators.count {
            scrollToItem(at: IndexPath(item: fromIndex, section: 0), at: .left, animated: false)
        } else {
            log.assert("incorrect from index")
        }
    }

    func invalidateLayout() {
        flowLayout.invalidateLayout()
    }

    func indicatorWithIndexForItem(at point: CGPoint) -> (DotaStatisticViewModel.Indicator, Int)? {
        guard let indexPath = indexPathForItem(at: point) else {
            return nil
        }

        let index = indexPath.item
        if 0 <= index && index <= indicators.count {
            return (indicators[index], index)
        }

        return nil
    }

    private func commonInit() {
        register(BarCell.self, forCellWithReuseIdentifier: BarCell.identifier)
        delegate = self
        dataSource = self
        clipsToBounds = true

        flowLayout.scrollDirection = .horizontal
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    fileprivate func recalculateVisibleMaxSum() {
        var newVisibleMaxSum: Int = 0

        for index in indexPathsForVisibleItems.map({ $0.item }) {
            let maxSum = indicators[index].values.reduce(0, +)
            if maxSum > newVisibleMaxSum {
                newVisibleMaxSum = maxSum
            }
        }

        var mult: Int = 10
        repeat {
            let divide = mult
            let halfDivide = mult / 2

            mult *= 10
            let halfMult = mult / 2

            if newVisibleMaxSum < halfMult {
                newVisibleMaxSum = newVisibleMaxSum + (halfDivide - newVisibleMaxSum % halfDivide)
            } else if newVisibleMaxSum < mult {
                newVisibleMaxSum = newVisibleMaxSum + (divide - newVisibleMaxSum % divide)
            }
        } while mult < newVisibleMaxSum

        visibleMaxSum = newVisibleMaxSum
    }

    fileprivate func reconfigureVisibleCells(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.reconfigureVisibleCells(animated: false)
            }
        } else {
            for barCell in visibleCells.compactMap({ $0 as? BarCell }) {
                barCell.reconfigure(colors: barColors, visibleMaxSum: visibleMaxSum, selectedIndex: selectedIndex)
            }
        }
    }

}

extension DotaGraphic: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollCallback?()
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Self.itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Self.itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: indicatorWidth, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indicators.count
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
                              visibleMaxSum: visibleMaxSum,
                              index: indexPath.row,
                              selectedIndex: selectedIndex)

            addViewForStylizing(barCell)
        }
    }
}

private class BarCell: UICollectionViewCell, StylizingView
{
    static let identifier: String = "\(BarCell.self)"
    private var prevVisibleMaxSum: Int = 0
    private var indicator: DotaStatisticViewModel.Indicator?
    private var cellIndex: Int = -1

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

    func reconfigure(colors: [UIColor], visibleMaxSum: Int, selectedIndex: Int?) {
        configureSelected(selectedIndex: selectedIndex)

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
                   visibleMaxSum: Int,
                   index: Int,
                   selectedIndex: Int?) {
        log.assert(indicator.values.count == colors.count, "invalid values count")
        self.indicator = indicator
        self.prevVisibleMaxSum = visibleMaxSum
        self.cellIndex = index

        configureSelected(selectedIndex: selectedIndex)

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
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.5
        dateLabel.font = style.fonts.content
        dateLabel.textColor = style.colors.mainText
        dateLabel.textAlignment = .center
    }

    // TODO: конечно тут можно и покрасивее, но это зато быстро
    private func configureSelected(selectedIndex: Int?) {
        if let selectedIndex = selectedIndex {
            let isSelected = selectedIndex == cellIndex
            contentView.alpha = isSelected ? 1.0 : 0.25
        } else {
            contentView.alpha = 1.0
        }
    }

    private func configureDateLabel(date: Date, interval: DotaStatisticViewModel.Interval) {
        dateLabel.frame.size = CGSize(width: contentView.frame.width, height: 35.0)
        dateLabel.frame.origin = CGPoint(x: 0, y: contentView.frame.height - dateLabel.frame.size.height)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = interval.twoLineFormat
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
