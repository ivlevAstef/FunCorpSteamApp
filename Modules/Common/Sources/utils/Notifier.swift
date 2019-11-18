//
//  Notifier.swift
//  Core
//
//  Created by Alexander Ivlev on 25/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

/// Need for simplify return result - not need write more closures, and not need retain all owners.
/// For example:
/// ```
/// class A {
///   let successNotifier = Notifier<Bool>()
///   let stateNotifier = Notifier<State>()
///   ...
///   successNotifier.notify(success)
///   ...
///   stateNotifier.notify(.failed)
/// }
///
/// class B {
///   let notifier = Notifier<Bool>()
///   ...
///   a.successNotifier.join(notifier)
///   a.stateNotifier.join(notifier, map: { state -> Bool in
///     return state == .success
///   })
/// }
///
/// class C {
///   ...
///   b = B()
///   ...
///   b?.notifier.join { [weak self] success in
///     ...
///   }
///   ...
///   b = nil
///   // b deinited, but if A notify then C received result
/// }
/// ```
public final class Notifier<Result>
{
    private class Listener {
        let shortPath: String
        let call: (Result) -> Void
        let needRemove: () -> Bool

        init(shortPath: String, call: @escaping (Result) -> Void, needRemove: @escaping () -> Bool = { return false }) {
            self.shortPath = shortPath
            self.call = call
            self.needRemove = needRemove
        }
    }

    private let name: String
    private let line: UInt

    private let locker = FastLock()
    private var listeners: [Listener] = []

    public init(file: String = #file, line: UInt = #line) {
        self.name = file.components(separatedBy: ["\\","/"]).last ?? "unknown"
        self.line = line
    }

    public init(listener: @escaping (Result) -> Void, file: String = #file, line: UInt = #line) {
        self.name = file.components(separatedBy: ["\\","/"]).last ?? "unknown"
        self.line = line
        self.join(listener: listener, file: file, line: line)
    }

    public init<ListenerResult>(_ listener: Notifier<ListenerResult>,
                                map: @escaping (Result) -> ListenerResult,
                                file: String = #file,
                                line: UInt = #line) {
        self.name = file.components(separatedBy: ["\\","/"]).last ?? "unknown"
        self.line = line
        self.join(listener, map: map)
    }

    // MARK: - strong joins
    
    /// Add listener into listeners list for notify about changes.
    /// - Parameter listener: Closure for receive result.
    public func join(listener: @escaping (Result) -> Void,
                     file: String = #file, line: UInt = #line) {
        let name = file.components(separatedBy: ["\\","/"]).last ?? "unknown"

        locker.lock()
        defer { locker.unlock() }

        listeners.append(Listener(shortPath: "Closure<\(name):\(line)>", call: listener))
    }

    /// Add listener into listeners list for notify about changes.
    /// - Parameter listener: Notifier for receive result, and notify self listeners.
    public func join(_ listener: Notifier<Result>) {
        locker.lock()
        defer { locker.unlock() }

        listeners.append(Listener(shortPath: "\(listener)", call: { result in
            listener.notify(result)
        }))
    }

    /// Add listener into listeners list for notify about changes.
    /// - Parameter listener: Notifier for receive result, and notify self listeners.
    /// - Parameter map: Method for convert result to listener result type.
    public func join<ListenerResult>(_ listener: Notifier<ListenerResult>,
                                     map: @escaping (Result) -> ListenerResult) {
        locker.lock()
        defer { locker.unlock() }

        listeners.append(Listener(shortPath: "\(listener)", call: { result in
            listener.notify(map(result))
        }))
    }

    // MARK: - weak joins

    /// Add listener into listeners list for notify about changes.
    /// Removed if owner deinited.
    /// - Parameter listener: Closure for receive result.
    /// - Parameter owner: Owner for check need call listener - call only if not nil.
    public func weakJoin<Owner: AnyObject>(listener: @escaping (Owner, Result) -> Void,
                                           owner: Owner,
                                           file: String = #file, line: UInt = #line) {
        let name = file.components(separatedBy: ["\\","/"]).last ?? "unknown"

        locker.lock()
        defer { locker.unlock() }

        listeners.append(Listener(shortPath: "Closure<\(name):\(line)>", call: { [weak owner] result in
            if let owner = owner {
                listener(owner, result)
            }
        }, needRemove: { [weak owner] in return nil == owner }))
    }

    /// Add listener into listeners list for notify about changes.
    /// If all retains removed from listeners then listener not notify about changes.
    /// - Parameter listener: If don't deinited notifier for receive result, and notify self listeners.
    public func weakJoin(_ listener: Notifier<Result>) {
        locker.lock()
        defer { locker.unlock() }

        listeners.append(Listener(shortPath: "\(listener)", call: { [weak listener] result in
            listener?.notify(result)
        }, needRemove: { [weak listener] in return nil == listener }))
    }

    /// Add listener into listeners list for notify about changes.
    /// If all retains removed from listeners then listener not notify about changes.
    /// - Parameter listener: If don't deinited notifier for receive result, and notify self listeners.
    /// - Parameter map: Method for convert result to listener result type.
    public func weakJoin<ListenerResult>(_ listener: Notifier<ListenerResult>,
                                         map: @escaping (Result) -> ListenerResult) {
        locker.lock()
        defer { locker.unlock() }

        listeners.append(Listener(shortPath: "\(listener)", call: { [weak listener] result in
            listener?.notify(map(result))
        }, needRemove: { [weak listener] in return nil == listener }))
    }

    /// add listener into listeners list for notify about changes.
    /// if all retains removed from listeners then listener not notify about changes.
    /// Also removed if owner deinited.
    /// - Parameter listener: If don't deinited notifier for receive result, and notify self listeners.
    /// - Parameter owner: Owner for check need call listener - call only if not nil.
    /// - Parameter map: Method for convert result to listener result type.
    public func weakJoin<ListenerResult, Owner: AnyObject>(_ listener: Notifier<ListenerResult>,
                                                           owner: Owner,
                                                           map: @escaping (Owner, Result) -> ListenerResult) {
        locker.lock()
        defer { locker.unlock() }

        listeners.append(Listener(shortPath: "\(listener)", call: { [weak owner, weak listener] result in
            if let owner = owner, let listener = listener {
                listener.notify(map(owner, result))
            }
        }, needRemove: { [weak owner, weak listener] in return nil == owner || nil == listener }))
    }

    // MARK: - notify

    /// Notify all listeners about new result.
    /// - Parameter result: Result data for move all listeners.
    public func notify(_ result: Result) {
        locker.lock()
        log.assert(listeners.count > 0, "\(self) not has listeners - maybe needs join?")

        listeners.removeAll(where: { $0.needRemove() })
        // need copy for unlock (because call need unknown time), but not crash in multithread
        let copyListeners = listeners

        locker.unlock()

        for listener in copyListeners {
            listener.call(result)
        }
    }

    public func hasListeners() -> Bool {
        locker.lock()
        defer { locker.unlock() }
        return !listeners.isEmpty
    }
}

// MARK: - support debug information

extension Notifier
{
    /// Return string with information about Notiier, and all current listeners.
    /// Potencial could contains weak join - listeners prints, but not called. But after call this listeners removed.
    public var information: String {
        locker.lock()
        listeners.removeAll(where: { $0.needRemove() })
        // need copy for unlock (because work with string is slow), but not crash in multithread
        let copyListeners = listeners
        locker.unlock()

        if copyListeners.isEmpty {
            return "\(self) Listeners empty"
        }

        var result = "\(self) Listeners: ["
        result += copyListeners.map{ "    " + $0.shortPath }.joined(separator: ",\n")
        result += "]\n"

        return result
    }
}

// MARK: - utility and debug

extension Notifier: CustomDebugStringConvertible, CustomStringConvertible
{
    public var debugDescription: String {
        return "Notifier<\(name):\(line)>"
    }

    public var description: String {
        return "Notifier<\(name):\(line)>"
    }
}
