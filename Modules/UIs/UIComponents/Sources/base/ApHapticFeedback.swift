//
//  ApHapticFeedback.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 03/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import CoreHaptics

public enum ApFeedbackGenerator {
    case impact(UIImpactFeedbackGenerator, intensity: CGFloat)
    case notification(UINotificationFeedbackGenerator, type: UINotificationFeedbackGenerator.FeedbackType)
    case selection(UISelectionFeedbackGenerator)
}

public class AppHapticFeedback {
    private let feedback: ApFeedbackGenerator

    public static func test() {
    }

    public static func preview() -> AppHapticFeedback {
        // TODO: need use CoreHaptic for improve
        return AppHapticFeedback(feedback: .impact(UIImpactFeedbackGenerator(style: .heavy), intensity: 1.0))
    }

    public func noise() {
        switch feedback {
        case let .impact(generator, intensity):
            if #available(iOS 13.0, *) {
                generator.impactOccurred(intensity: intensity)
            } else {
                generator.impactOccurred()
            }
        case let .notification(generator, type):
            generator.notificationOccurred(type)
        case let .selection(generator):
            generator.selectionChanged()
        }
    }

    public init(feedback: ApFeedbackGenerator) {
        self.feedback = feedback
    }
}
