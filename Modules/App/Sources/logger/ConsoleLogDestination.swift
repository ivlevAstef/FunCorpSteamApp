//
//  ConsoleLogDestination.swift
//  Logger
//
//  Created by Alexander Ivlev on 25/02/2019.
//

import Foundation
import Common

final class ConsoleLogDestination: LogDestination
{
    let format: String
    let limitOutputLevel: LogLevel

    init(format: String = " [%L] %F:%l: %m", limitOutputLevel: LogLevel = .trace) {
        self.format = format
        self.limitOutputLevel = limitOutputLevel
    }

    func process(_ msg: String, level: LogLevel) {
        // Не print ибо print не показывается в консоле девайса
        // То есть print имеет смысл только при запуске прям из xCode, а просто посмотреть логи на устройстве с помощью print нельзя
        NSLog(msg)
    }

}
