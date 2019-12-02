//
//  CustomDotaCell.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents
import AppUIComponents
import SnapKit


final class CustomDotaCell: ApTableViewCell
{
    static let preferredHeight: CGFloat = 50.0
    static let identifier = "\(CustomDotaCell.self)"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: SkeletonViewModel<GameInfoViewModel>) {
        contentView.subviews.forEach { stylizingSubviews.append($0.skeletonView) }
        switch viewModel {
        case .loading:
            contentView.subviews.forEach { $0.startSkeleton() }
        case .failed:
            contentView.subviews.forEach { $0.failedSkeleton() }
        case .done(let viewModel):
            contentView.subviews.forEach { $0.endSkeleton() }
        }
    }

    private func commonInit() {
    }

    override func apply(use style: Style) {
        super.apply(use: style)

        contentView.backgroundColor = .red

        relayout(use: style.layout)
    }

    private func relayout(use layout: Style.Layout) {
    }
}
