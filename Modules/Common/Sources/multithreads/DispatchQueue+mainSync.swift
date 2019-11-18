//
//  DispatchQueue+mainSync.swift
//  Common
//
//  Created by Alexander Ivlev on 29/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public extension DispatchQueue
{
    static func mainSync(execute: () -> Void) {
        if Thread.isMainThread {
            execute()
        } else {
            DispatchQueue.main.sync(execute: execute)
        }
    }

    static func mainSync<T>(execute: () throws -> T) rethrows -> T {
        if Thread.isMainThread {
            return try execute()
        } else {
            return try DispatchQueue.main.sync(execute: execute)
        }
    }
}
