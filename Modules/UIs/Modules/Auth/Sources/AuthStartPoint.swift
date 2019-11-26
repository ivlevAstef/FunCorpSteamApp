//
//  AuthStartPoint.swift
//  Auth
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Core
import DITranquillity
import SwiftLazy

public final class AuthStartPoint: UIStartPoint
{
    public static let name: UIModuleName = .auth

    public struct Subscribers {
        public let authSuccessNotifier: Notifier<RoutingParamaters>
    }
    public var subscribersFiller: (_ navigator: Navigator, _ subscribers: Subscribers) -> Void = { _, _ in }

    private var routerProvider = Provider1<AuthRouter, Navigator>()

    public init() {

    }
    
    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: AuthDependency.self)
        routerProvider = container.resolve()
    }

    public func initialize() {

    }

    public func isSupportOpen(with parameters: RoutingParamaters) -> Bool {
        return parameters.moduleName == Self.name
    }

    public func makeRouter(use navigator: Navigator) -> IRouter {
        let router = routerProvider.value(navigator)
        subscribersFiller(navigator, Subscribers(
            authSuccessNotifier: router.authSuccessNotifier
        ))

        return router
    }

}
