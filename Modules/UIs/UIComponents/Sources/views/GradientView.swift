//
//  GradientItemView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 27/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design
import Common

public class GradientView: UIView {
    public override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    public var gradient: Gradient? {
        didSet { updateGradient() }
    }

    public var startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0) {
        didSet { updateGradient() }
    }

    public var endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0) {
       didSet { updateGradient() }
    }

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateGradient() {
        guard let layer = self.layer as? CAGradientLayer else {
            log.assert("Gradient view layer have incorrect type")
            return
        }

        guard let gradient = self.gradient else {
            layer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
            return
        }

        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.colors = [gradient.from.cgColor, gradient.to.cgColor]
    }

}
