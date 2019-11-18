//
//  CommonStartPoint.swift
//  Core
//
//  Created by Alexander Ivlev on 23/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity

public protocol CommonStartPoint
{
    /// Pre configure module. Called before reg
    func configure()

    /// Registrate dependencies
    /// - Parameter container: common container for registration dependencies
    func reg(container: DIContainer)

    /// Post configure module. Called after reg
    func initialize()
}

