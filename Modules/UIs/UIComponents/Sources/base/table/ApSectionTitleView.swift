//
//  ApSectionTitleView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 26/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import Common

public class ApSectionTitleView: UIView
{
    private let titleLabel: UILabel = UILabel(frame: .zero)

    public init(text: String) {
        super.init(frame: .zero)

        commonInit(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit(text: String) {
        addSubview(titleLabel)

        titleLabel.text = text
    }
}

extension ApSectionTitleView: StylizingView
{
    public func apply(use style: Style) {
        backgroundColor = .clear

        titleLabel.font = style.fonts.title
        titleLabel.textColor = style.colors.mainText

        titleLabel.snp.remakeConstraints { maker in
            maker.top.equalToSuperview().offset(4.0)
            maker.left.equalToSuperview().offset(style.layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-style.layout.cellInnerInsets.right)
            maker.bottom.equalToSuperview().offset(-4.0)
        }
    }
}
