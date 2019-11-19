//
//  LogDestination.swift
//  Logger
//
//  Created by Alexander Ivlev on 22/02/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

/// Протокол от которого должны наследоваться все потоки вывода.
public protocol LogDestination: class
{
    // формат:
    // %Dx - вывод даты варианты:
    //   %Dd (debug) - mm:ss.SSS
    //   %Dn (nano) - HH:mm:ss.SSS
    //   %Da (any) - yyyy-MM-dd HH:mm:ss.SSS
    //   %Df (file) - MM-dd HH:mm:ss
    // %L - вывод уровня логирования
    // %s - вывод уровня логирования в коротком варианте
    // %e - вывод уровня логирования используя emoji
    // %F - вывод имени файла
    // %l - вывод строчки
    // %M - вывод метода
    // %m - вывод сообщения
    var format: String { get }

    /// Максимально допустимый уровень логирования - выше этого уровня логи не будут приходить в функцию process
    var limitOutputLevel: LogLevel { get }

    /// Обработчик нового сообщения от логгера. Сообщение приходит в конечном варианте - отформатированным
    ///
    /// - Parameters:
    ///   - msg: Отформатированное сообщение
    ///   - level: Уровень логирования для этого сообщения
    func process(_ msg: String, level: LogLevel)
}
