//
//  LogInitialization.swift
//  ApLife
//
//  Created by Alexander Ivlev on 02/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

final class LogInitialization
{
    static func configure() {
        #if DEBUG
            log.addDestination(XcodeDebugLogDestination(format: " [%e] %F:%l: %m", limitOutputLevel: .trace))
        #else
            log.addDestination(ConsoleLogDestination(format: " [%s] %F:%l: %m", limitOutputLevel: .info))
            log.addDestination(LogFileDestination(format: "%Df [%s]: %m", limitOutputLevel: .info))
        #endif
    }
}
