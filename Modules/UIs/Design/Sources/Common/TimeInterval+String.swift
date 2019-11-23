//
//  TimeInterval+String.swift
//  Design
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common

extension TimeInterval {
    public var adaptiveString: String {
        if self < 60 { // seconds
            let seconds = Int(self)
            return "\(seconds) \(loc["TimeInterval.short.seconds"])"
        } else if self < 60 * 60 { // minutes
            let minutes = Int(self / 60)
            return "\(minutes) \(loc["TimeInterval.short.minutes"])"
        } else { // hours
            let hours = Int(self / (60 * 60))
            return "\(hours) \(loc["TimeInterval.short.hours"])"
        }
    }
}

