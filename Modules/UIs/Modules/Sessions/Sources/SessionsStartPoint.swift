//
//  SessionsStartPoint.swift
//  Sessions
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity
import Design
import SwiftLazy

public final class SessionsStartPoint: UIStartPoint
{
    public static let name: UIModuleName = .sessions

    private var routerProvider = Provider1<SessionsRouter, Navigator>()

    public init() {

    }

    public func configure() {
    }

    public func reg(container: DIContainer) {
        container.append(framework: SessionsDependency.self)
        routerProvider = container.resolve()
    }

    public func initialize() {
        // TODO: setup style
    }

    public func isSupportOpen(with parameters: RoutingParamaters) -> Bool {
       return parameters.moduleName == Self.name
    }

    public func makeRouter(use navigator: Navigator) -> IRouter {
        return routerProvider.value(navigator)
    }

}
