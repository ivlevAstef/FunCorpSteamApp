//
//  StorageStartPoint.swift
//  Storage
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity

public final class StorageStartPoint: CommonStartPoint
{
    public init() {

    }

    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: StorageDependency.self)
    }

    public func initialize() {
    }
}
