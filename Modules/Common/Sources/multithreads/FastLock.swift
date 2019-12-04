//
//  FastLock.swift
//  Common
//
//  Created by Alexander Ivlev on 26/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public final class FastLock
{
    private var monitor: os_unfair_lock = os_unfair_lock()

    public init() {
        
    }

    public func lock() {
        os_unfair_lock_lock(&monitor)
    }

    public func unlock() {
        os_unfair_lock_unlock(&monitor)
    }
}
