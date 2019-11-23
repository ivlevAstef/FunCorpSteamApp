//
//  RoutingParamaters.swift
//  Core
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public struct RoutingParamaters
{
    public var isEmpty: Bool {
        return moduleName != nil
    }
    public let moduleName: UIModuleName?
    public let options: [String: String]

    public init() {
        self.moduleName = nil
        self.options = [:]
    }

    public init(moduleName: UIModuleName, options: [String: String] = [:]) {
        self.moduleName = moduleName
        self.options = options
    }
}

extension RoutingParamaters: Equatable
{
    public static func ==(lhs: RoutingParamaters, rhs: RoutingParamaters) -> Bool {
        return lhs.moduleName == rhs.moduleName && lhs.options == rhs.options
    }
}
