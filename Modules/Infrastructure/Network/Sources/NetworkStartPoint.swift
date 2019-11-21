//
//  NetworkStartPoint.swift
//  Network
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity

public final class NetworkStartPoint: CommonStartPoint
{
    public init() {

    }

    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: NetworkDependency.self)
    }

    public func initialize() {
    }
}
