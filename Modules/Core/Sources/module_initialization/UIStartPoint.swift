//
//  UIStartPoint.swift
//  Core
//
//  Created by Alexander Ivlev on 23/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public protocol UIStartPoint: CommonStartPoint
{
    static var name: UIModuleName { get }

    /// check for can make and start this module for paramater
    /// - Parameter parameters: start parameters
    func isSupportOpen(with parameters: RoutingParamaters) -> Bool

    /// make router for startup project
    func makeRouter() -> IRouter
}
