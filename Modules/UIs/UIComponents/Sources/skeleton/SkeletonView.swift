//
//  SkeletonView.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Design

public final class SkeletonView: UIView {
    public enum State {
        case stopped
        case animated
        case failed
    }

    private let gradientLayer = CAGradientLayer()
    private let failedLayer = CALayer()
    private var gradient: Gradient = Gradient(from: .brown, to: .brown)
    private var failedColor: UIColor = .red

    public private(set) var state: State = .stopped
    private var prevSize: CGSize = .zero

    public init() {
        super.init(frame: .zero)

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func start() {
        if state == .animated {
            return
        }

        state = .animated
        update()
    }

    public func end() {
        if state == .stopped {
            return
        }

        state = .stopped
        update()
    }

    public func failed() {
        if state == .failed {
            return
        }

        state = .failed
        update()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if !prevSize.equalTo(frame.size) {
            prevSize = frame.size

            layer.cornerRadius = min(frame.size.width, frame.size.height) * 0.1
            // Переносим скругление с родителя, если оно у него есть
            if let superCornerRadius = superview?.layer.cornerRadius, superCornerRadius >= 1 {
                layer.cornerRadius = superCornerRadius
            }

            update()
        }
    }

    private func commonInit() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        layer.cornerRadius = 5.0
        layer.masksToBounds = true

        gradientLayer.opacity = 0.0
        failedLayer.opacity = 0.0

        layer.addSublayer(gradientLayer)
        layer.addSublayer(failedLayer)
    }

    private func update() {
        if bounds.size.width.isEqual(to: .zero) || bounds.size.height.isEqual(to: .zero) {
            return
        }

        if state == .failed {
            failedLayer.opacity = 1.0
            gradientLayer.opacity = 0.0
        } else if state == .stopped {
            failedLayer.opacity = 0.0
            gradientLayer.opacity = 0.0
        } else {
            failedLayer.opacity = 0.0
            gradientLayer.opacity = 1.0
        }

        failedLayer.backgroundColor = failedColor.cgColor

        gradientLayer.colors = [gradient.from.cgColor, gradient.to.cgColor, gradient.from.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.05 * bounds.height / bounds.width)

        failedLayer.frame = CGRect(origin: .zero, size: bounds.size)
        gradientLayer.frame = CGRect(origin: .zero, size: bounds.size)

        gradientLayer.removeAnimation(forKey: "gradient_animations")
        if state == .animated {
            // TODO: конечно не идеальная, но времени делать её идеальной нет
            let animations = CAAnimationGroup()
            let duration = 1.5

            let rightAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
            rightAnimation.fromValue = [0.0, -1.0, 1.0]
            rightAnimation.toValue = [0.0, 2.0, 1.0]
            rightAnimation.duration = duration

            let leftAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
            leftAnimation.fromValue = [0.0, 2.0, 1.0]
            leftAnimation.toValue = [0.0, -1.0, 1.0]
            leftAnimation.duration = duration
            leftAnimation.beginTime = duration

            animations.animations = [rightAnimation, leftAnimation]
            animations.timingFunction = CAMediaTimingFunction(name: .linear)
            animations.duration = 2 * duration
            animations.repeatCount = .infinity

            gradientLayer.add(animations, forKey: "gradient_animations")
        }
    }
}


extension SkeletonView: StylizingView {
    public func apply(use style: Style) {
        if gradient == style.colors.skeleton && failedColor == style.colors.skeletonFailed {
            return
        }

        gradient = style.colors.skeleton
        failedColor = style.colors.skeletonFailed
        update()
    }
}
