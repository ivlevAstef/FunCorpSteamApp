//
//  MenuStartPoint.swift
//  Menu
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import Common
import DITranquillity
import SwiftLazy

public final class MenuStartPoint: UIStartPoint
{
    public static let name: UIModuleName = .menu

    public struct Subscribers {
        public let newsGetter: Getter<Navigator, IRouter>
        public let myProfileGetter: Getter<Navigator, IRouter>
        public let sessionsGetter: Getter<Navigator, IRouter>
    }
    public var subscribersFiller: (_ navigator: Navigator, _ subscribers: Subscribers) -> Void = { _, _ in }

    private var routerProvider = Provider1<MenuRouter, Navigator>()

    public init() {

    }

    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: MenuDependency.self)
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
            newsGetter: router.newsGetter,
            myProfileGetter: router.myProfileGetter,
            sessionsGetter: router.sessionsGetter
        ))

        return router
    }

}
