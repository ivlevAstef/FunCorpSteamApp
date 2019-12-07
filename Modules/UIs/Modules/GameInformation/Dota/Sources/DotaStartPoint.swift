//
//  DotaStartPoint.swift
//  Dota
//
//  Created by Alexander Ivlev on 07/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity

public final class DotaStartPoint: CommonStartPoint
{
    public init() {

    }

    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: DotaDependency.self)
    }

    public func initialize() {
    }
}
