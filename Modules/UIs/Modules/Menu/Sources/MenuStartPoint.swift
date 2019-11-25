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

    public let newsGetter = Getter<Navigator, IRouter>()
    public let myProfileGetter = Getter<Navigator, IRouter>()
    public let sessionsGetter = Getter<Navigator, IRouter>()

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
        router.newsGetter.take(from: newsGetter)
        router.myProfileGetter.take(from: myProfileGetter)
        router.sessionsGetter.take(from: sessionsGetter)

        return router
    }

}
