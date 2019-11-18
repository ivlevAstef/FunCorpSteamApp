//
//  Weak.swift
//  Common
//
//  Created by Alexander Ivlev on 01/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public class Weak<T>
{
    public var value: T? {
        return _value as? T
    }

    private weak var _value: AnyObject?

    public init(_ value: T) {
        _value = value as AnyObject
    }
}

public class WeakRef<T: AnyObject>
{
    public private(set) weak var value: T?

    public init(_ value: T) {
        self.value = value
    }
}

extension Weak: Equatable where T: Equatable
{
    public static func ==(_ lhs: Weak<T>, _ rhs: Weak<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Weak: Hashable where T: Hashable
{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension WeakRef: Equatable where T: Equatable
{
    public static func ==(_ lhs: WeakRef<T>, _ rhs: WeakRef<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

extension WeakRef: Hashable where T: Hashable
{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
