//
//  RoutingParamaters.swift
//  Core
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public struct RoutingParamaters
{
    public let isEmpty: Bool
    public let moduleName: UIModuleName?

    public init() {
        self.isEmpty = true
        self.moduleName = nil
    }

    public init(moduleName: UIModuleName) {
        self.isEmpty = false
        self.moduleName = moduleName
    }
}
