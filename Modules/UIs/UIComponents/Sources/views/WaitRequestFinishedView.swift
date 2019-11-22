//
//  WaitRequestFinishedView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import SnapKit

private enum Consts {
    static let inset: CGFloat = 16.0
}

public final class WaitRequestFinishedView: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let infoLabel = UILabel(frame: .zero)
    private let shadowView = UIView(frame: .zero)

    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    public func show(_ text: String, animateDuration: TimeInterval) {
        infoLabel.text = text
        activityIndicator.startAnimating()

        isHidden = false
        UIView.animate(withDuration: animateDuration) {
            self.alpha = 1.0
        }
    }

    public func hide(animateDuration: TimeInterval) {
        activityIndicator.stopAnimating()

        UIView.animate(withDuration: animateDuration, animations: {
            self.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.isHidden = true
        })
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        alpha = 0.0
        isHidden = true

        addSubview(shadowView)
        shadowView.addSubview(activityIndicator)
        shadowView.addSubview(infoLabel)

        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0

        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = Consts.inset
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.cornerRadius = Consts.inset

        shadowView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(Consts.inset)
            maker.left.equalToSuperview().offset(Consts.inset)
            maker.right.equalToSuperview().offset(-Consts.inset)
            maker.bottom.equalToSuperview().offset(-Consts.inset)
        }

        activityIndicator.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(Consts.inset)
        }

        infoLabel.snp.makeConstraints { maker in
            maker.top.equalTo(activityIndicator.snp.bottom).offset(Consts.inset)
            maker.left.equalToSuperview().offset(Consts.inset)
            maker.right.equalToSuperview().offset(-Consts.inset)
            maker.bottom.equalToSuperview().offset(-Consts.inset)
        }
    }
}

extension WaitRequestFinishedView: StylizingView {
    public func apply(use style: Style) {
        backgroundColor = .clear
        layer.shadowColor = style.colors.accent.cgColor
        shadowView.backgroundColor = style.colors.accent.withAlphaComponent(0.3)

        activityIndicator.color = style.colors.mainText
        infoLabel.font = style.fonts.subtitle
        infoLabel.textColor = style.colors.mainText
    }
}
