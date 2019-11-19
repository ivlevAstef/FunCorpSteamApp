//
//  Logger+Levels.swift
//  Logger
//
//  Created by Alexander Ivlev on 25/02/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


// MARK: - Расширения для более удобного логирования
extension Logger
{
    /// Функция логирования критической ошибки. После исполнения этой функции программа точно упадет. более подробно см `LogLevel`
    public func fatal(_ msg: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) -> Never {
        other(.fatal, msg(), path: path, line: line, fun: fun)
        waitUntilAllOperationsAreFinished()
        fatalError(msg(), file: path, line: line)
    }

    /// эквивалент assertionFailure, но с той лишь разницей что в релиз сборке данная проблема попадет в лог. более подробно см `LogLevel`
    public func assert(_ msg: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) {
        other(.assert, msg(), path: path, line: line, fun: fun)
        #if DEBUG
        waitUntilAllOperationsAreFinished()
        assertionFailure(msg(), file: path, line: line)
        #endif
    }

    /// эквивалент assert, но с той лишь разницей что в релиз сборке данная проблема попадет в лог. более подробно см `LogLevel`
    public func assert(_ condition: Bool, _ msg: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) {
        if !condition {
            other(.assert, msg(), path: path, line: line, fun: fun)
            #if DEBUG
            waitUntilAllOperationsAreFinished()
            assertionFailure(msg(), file: path, line: line)
            #endif
        }
    }

    /// Функция логирования не критической ошибки. более подробно см `LogLevel`
    public func error(_ msg: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) {
        other(.error, msg(), path: path, line: line, fun: fun)
    }

    /// Функция логирования предупреждения. более подробно см `LogLevel`
    public func warning(_ msg: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) {
        other(.warning, msg(), path: path, line: line, fun: fun)
    }

    /// Функция логирования информации. более подробно см `LogLevel`
    public func info(_ msg: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) {
        other(.info, msg(), path: path, line: line, fun: fun)
    }

    /// Функция логирования дебаг информации. более подробно см `LogLevel`
    public func debug(_ msg: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) {
        other(.debug, msg(), path: path, line: line, fun: fun)
    }

    /// Функция логирования не важной информации. более подробно см `LogLevel`
    public func trace(_ msg: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) {
        other(.trace, msg(), path: path, line: line, fun: fun)
    }

}

