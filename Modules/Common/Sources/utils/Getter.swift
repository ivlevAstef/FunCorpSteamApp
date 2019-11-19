//
//  Getter.swift
//  Common
//
//  Created by Alexander Ivlev on 03/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

protocol AbstractGetter: class {
    func hasCallback() -> Bool
}

/// Need for simplify get value without real dependency - not need write more closures. Something like Provider.
public final class Getter<Params, Value>: AbstractGetter
{
    private let name: String
    private let line: UInt

    private let locker = FastLock()
    private var callback: ((Params) -> Value?)?
    private var callbackPath: String?
    private weak var parent: AbstractGetter?

    public init(file: String = #file, line: UInt = #line) {
        self.name = file.components(separatedBy: ["\\","/"]).last ?? "unknown"
        self.line = line
    }

    // MARK: - take

    /// Setup callback for get value by params.
    /// - Parameter callback: Closure for get value.
    public func take(use callback: @escaping (Params) -> Value?,
                     file: String = #file, line: UInt = #line) {
        let name = file.components(separatedBy: ["\\","/"]).last ?? "unknown"

        locker.lock()
        defer { locker.unlock() }

        self.parent = nil
        self.callback = callback
        self.callbackPath = "Closure<\(name):\(line)>"
    }

    /// Setup getter for get value by params.
    /// - Parameter from: Getter for get value by params.
    public func take(from: Getter<Params, Value>) {
        locker.lock()
        defer { locker.unlock() }

        self.parent = from
        self.callback = { params in
            return from.get(params)
        }
        self.callbackPath = "\(from)"
    }

    /// Setup getter for get value by params, and use map.
    /// - Parameter from: Getter for get value by params.
    /// - Parameter paramsMap: Mapper for convert parameter.
    /// - Parameter valueMap: Mapper for convert value..
    public func take<FromParams, FromValue>(from: Getter<FromParams, FromValue>,
                                            paramsMap: @escaping (Params) -> FromParams,
                                            valueMap: @escaping (FromValue?) -> Value?) {
        locker.lock()
        defer { locker.unlock() }

        self.parent = from
        self.callback = { params in
            return valueMap(from.get(paramsMap(params)))
        }
        self.callbackPath = "\(from)"
    }

    public func take<FromValue>(from: Getter<Params, FromValue>,
                                valueMap: @escaping (FromValue?) -> Value?) {
        take(from: from, paramsMap: { $0 }, valueMap: valueMap)
    }

    public func take<FromParams>(from: Getter<FromParams, Value>,
                                 paramsMap: @escaping (Params) -> FromParams) {
        take(from: from, paramsMap: paramsMap, valueMap: { $0 })
    }

    // MARK: - get

    /// Get value by params.
    /// - Parameter params: Parameters for get value.
    public func get(_ params: Params) -> Value? {
        locker.lock()
        guard let callback = self.callback else {
            log.assert("\(self) not has callback - needs take!")
            return nil
        }

        // need copy for unlock (because call need unknown time), but not crash in multithread
        let copyCallback = callback

        locker.unlock()

        return copyCallback(params)
    }

    public func hasCallback() -> Bool {
        locker.lock()
        defer { locker.unlock() }

        if let parent = parent {
            return parent.hasCallback()
        }

        return nil != callback
    }
}

// MARK: - support debug information

extension Getter
{
    /// Return string with information about Notiier, and all current listeners.
    /// Potencial could contains weak join - listeners prints, but not called. But after call this listeners removed.
    public var information: String {
        locker.lock()
        // need copy for unlock (because work with string is slow), but not crash in multithread
        let copyCallbackPath = callbackPath
        locker.unlock()

        guard let callbackPath = copyCallbackPath else {
            return "\(self) Not callback"
        }

        return "\(self) Callback: \(callbackPath)"
    }
}

// MARK: - utility and debug

extension Getter: CustomDebugStringConvertible, CustomStringConvertible
{
    public var debugDescription: String {
        return "Getter<\(name):\(line)>"
    }

    public var description: String {
        return "Getter<\(name):\(line)>"
    }
}

