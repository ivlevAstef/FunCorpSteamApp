//
//  UseCasesImplStartPoint.swift
//  UseCasesImpl
//
//  Created by Alexander Ivlev on 20/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity

public final class UseCasesImplStartPoint: CommonStartPoint
{
    public init() {

    }

    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: UseCasesImplDependency.self)
    }

    public func initialize() {
    }
}
