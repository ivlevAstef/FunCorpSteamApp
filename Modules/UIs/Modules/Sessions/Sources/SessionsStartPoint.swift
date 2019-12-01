//
//  SessionsStartPoint.swift
//  Sessions
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Core
import DITranquillity
import SwiftLazy
import Services

public final class SessionsStartPoint: UIStartPoint
{
    public enum RoutingOptions {
        public static let steamId = "SteamId"
        // TODO: в будущем можно будет поддержать переход сразу на друга, от себя (то есть с полной навигацией)
    }

    public struct Subscribers {
        public let tapOnGameNotifier: Notifier<(SteamID, SteamGameID, Navigator)>
    }
    public var subscribersFiller: (_ navigator: Navigator, _ subscribers: Subscribers) -> Void = { _, _ in }

    public static let name: UIModuleName = .sessions

    private var routerProvider = Provider1<SessionsRouter, Navigator>()

    public init() {

    }

    public func makeParams(steamId: SteamID) -> RoutingParamaters {
        return RoutingParamaters(moduleName: Self.name, options: [
            RoutingOptions.steamId: "\(steamId)"
        ])
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
        let router = routerProvider.value(navigator)
        subscribersFiller(navigator, Subscribers(
            tapOnGameNotifier: router.tapOnGameNotifier
        ))

        return router
    }

}
