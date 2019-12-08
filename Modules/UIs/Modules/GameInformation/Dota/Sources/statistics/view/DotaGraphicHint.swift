//
//  DotaGraphicHint.swift
//  Dota
//
//  Created by Alexander Ivlev on 08/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import SnapKit
import UIComponents

final class DotaGraphicHint: UIView, StylizingView
{
    private let legendView: UIStackView = UIStackView(frame: .zero)
    private let dateLabel: UILabel = UILabel(frame: .zero)

    private var style: Style?

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(indicator: DotaStatisticViewModel.Indicator,
                   interval: DotaStatisticViewModel.Interval,
                   names: [String],
                   colors: [UIColor]) {
        log.assert(indicator.values.count == names.count && names.count == colors.count, "values, names, colors have not equal size")

        legendView.subviews.forEach { $0.removeFromSuperview() }
        for i in indicator.values.indices {
            let legendValue = LegendValue()
            legendValue.configure(value: indicator.values[i], color: colors[i], name: names[i])
            if let style = self.style {
                legendValue.apply(use: style)
            }

            legendView.addArrangedSubview(legendValue)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = interval.fullyFormat
        dateLabel.text = dateFormatter.string(from: indicator.date)
    }

    private func commonInit() {
        legendView.axis = .horizontal
        legendView.distribution = .equalSpacing
        legendView.alignment = .center
        legendView.spacing = 16.0

        legendView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(legendView)

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
    }

    func apply(use style: Style) {
        self.style = style
        for view in legendView.subviews.compactMap({ $0 as? StylizingView }) {
            view.apply(use: style)
        }

        backgroundColor = style.colors.accent

        dateLabel.numberOfLines = 1
        dateLabel.font = style.fonts.subtitle
        dateLabel.textColor = style.colors.contentText
        dateLabel.textAlignment = .center

        layer.cornerRadius = style.layout.cellInnerInsets.left

        relayout(use: style.layout)
    }

     private func relayout(use layout: Style.Layout) {
        legendView.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(2.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }

        dateLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(legendView.snp.bottom).offset(4.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
            maker.height.equalTo(dateLabel.font.lineHeight)
            maker.bottom.equalToSuperview().offset(-2.0)
        }
    }
}

private class LegendValue: UIView, StylizingView
{
    private let nameLabel: UILabel = UILabel(frame: .zero)
    private let valueLabel: UILabel = UILabel(frame: .zero)

    init() {
        super.init(frame: .zero)

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(value: Int, color: UIColor, name: String) {
        nameLabel.textColor = color
        nameLabel.text = name
        valueLabel.text = "\(value)"
    }

    private func commonInit() {
        addSubview(nameLabel)
        addSubview(valueLabel)

        valueLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(valueLabel.snp.bottom)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }

    func apply(use style: Style) {
        nameLabel.numberOfLines = 1
        nameLabel.font = style.fonts.content
        nameLabel.textAlignment = .center

        valueLabel.numberOfLines = 1
        valueLabel.font = style.fonts.subtitle
        valueLabel.textColor = style.colors.mainText
        valueLabel.textAlignment = .center
    }
}
