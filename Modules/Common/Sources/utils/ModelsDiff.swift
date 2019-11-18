//
//  ModelsDiff.swift
//  Common
//
//  Created by Alexander Ivlev on 30/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

@available(iOS 13, *)
public struct ModelsDiff<T: Equatable>
{
    public enum Change {
        case insert(T, at: Int)
        case remove(T, at: Int)
    }
    public let old: [T]
    public let new: [T]

    public let diff: [Change]

    public func make<T: Equatable>(old: [T], new: [T]) -> ModelsDiff<T> {
        let systemDiff = new.difference(from: old)
        var diff: [ModelsDiff<T>.Change] = []
        for systemAction in systemDiff {
            switch systemAction {
            case .insert(let offset, let element, _):
                diff.append(.insert(element, at: offset))
            case .remove(let offset, let element, _):
                diff.append(.remove(element, at: offset))
            }
        }

        return ModelsDiff<T>(old: old, new: new, diff: diff)
    }
}

