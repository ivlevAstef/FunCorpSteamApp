//
//  ProfileStartPoint.swift
//  Profile
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Core
import DITranquillity
import SwiftLazy
import Services

public final class ProfileStartPoint: UIStartPoint
{
    public enum RoutingOptions {
        public static let steamId = "ProfileSteamId"
        // TODO: в будущем можно будет поддержать переход сразу на друга, от себя (то есть с полной навигацией)
    }

    public struct Subscribers {
        public let tapOnGameNotifier: Notifier<(SteamID, SteamGameID, Navigator)>
    }
    public var subscribersFiller: (_ navigator: Navigator, _ subscribers: Subscribers) -> Void = { _, _ in }

    public static let name: UIModuleName = .profile

    private var routerProvider = Provider1<ProfileRouter, Navigator>()

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
        container.append(framework: ProfileDependency.self)
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
            tapOnGameNotifier: router.tapOnGameNotifier
        ))

        return router
    }

}
