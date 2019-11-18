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

    public let newsGetter = Getter<Void, IRouter>()
    public let myProfileGetter = Getter<Void, IRouter>()
    public let friendsGetter = Getter<Void, IRouter>()
    public let settingsGetter = Getter<Void, IRouter>()

    private var routerProvider = Provider<MenuRouter>()

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

    public func makeRouter() -> IRouter {
        let router = routerProvider.value
        router.newsGetter.take(from: newsGetter)
        router.myProfileGetter.take(from: myProfileGetter)
        router.friendsGetter.take(from: friendsGetter)
        router.settingsGetter.take(from: settingsGetter)

        return router
    }

}
