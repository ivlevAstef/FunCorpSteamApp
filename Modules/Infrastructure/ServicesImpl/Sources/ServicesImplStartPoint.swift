//
//  ServicesImplStartPoint.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 20/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity

public final class ServicesImplStartPoint: CommonStartPoint
{
    public init() {

    }

    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: ServicesImplDependency.self)
    }

    public func initialize() {
    }
}
