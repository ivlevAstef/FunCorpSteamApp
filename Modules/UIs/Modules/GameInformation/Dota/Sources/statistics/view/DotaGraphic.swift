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

final class DotaGraphic: UIView, StylizingView
{
    private var indicators: [DotaStatisticViewModel.Indicator] = []
    private(set) var indicatorWidth: CGFloat = 1.0

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false

        snp.remakeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalToSuperview()
        }
    }

    func configure(indicators: [DotaStatisticViewModel.Indicator], indicatorWidth: CGFloat) {
        self.indicators = indicators
        self.indicatorWidth = indicatorWidth

        let width = CGFloat(indicators.count) * indicatorWidth
        snp.remakeConstraints { maker in
            maker.width.equalTo(width)
            
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalToSuperview()
        }
    }

    func apply(use style: Style) {
        backgroundColor = .red
    }

}
