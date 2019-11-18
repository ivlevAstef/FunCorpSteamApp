//
//  XcodeDebugLogDestination.swift
//  Logger
//
//  Created by Alexander Ivlev on 25/02/2019.
//

import Foundation
import Common

final class XcodeDebugLogDestination: LogDestination
{
    let format: String
    let limitOutputLevel: LogLevel

    init(format: String = " [%e] %F:%l: %m", limitOutputLevel: LogLevel = .trace) {
        self.format = format
        self.limitOutputLevel = limitOutputLevel
    }

    func process(_ msg: String, level: LogLevel) {
        print(msg)
    }

}
