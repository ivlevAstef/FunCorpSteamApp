//
//  WeakArray.swift
//  Common
//
//  Created by Alexander Ivlev on 14/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public struct WeakArray<T>: Sequence
{
    public typealias Iterator = StrongIterator
    public struct StrongIterator: IteratorProtocol {
        public typealias Element = T

        private let data: [T]
        private var index: Int = 0

        fileprivate init(data: [T]) {
            self.data = data
        }

        public mutating func next() -> T? {
            if index < data.count {
                defer { index += 1 }
                return data[index]
            }
            return nil
        }
    }

    private var data: [Weak<T>] = []

    public init() {
        
    }

    public mutating func append(_ object: T) {
        data.removeAll(where: { $0.value == nil })
        data.append(Weak(object))
    }

    public mutating func remove(_ object: T) {
        data.removeAll(where: { $0.value as AnyObject === object as AnyObject || $0.value == nil })
    }

    public func makeIterator() -> Self.Iterator {
        return StrongIterator(data: data.compactMap { $0.value })
    }
}
