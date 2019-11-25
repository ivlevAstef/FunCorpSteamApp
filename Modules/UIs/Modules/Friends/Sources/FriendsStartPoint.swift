//
//  FriendsStartPoint.swift
//  Friends
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity
import SwiftLazy
import Services

public final class FriendsStartPoint: UIStartPoint
{
    public enum RoutingOptions {
        public static let steamId = "ProfileSteamId"
    }

    public static let name: UIModuleName = .friends

    private var routerProvider = Provider1<FriendsRouter, Navigator>()

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
        container.append(framework: FriendsDependency.self)
        routerProvider = container.resolve()
    }

    public func initialize() {

    }

    public func isSupportOpen(with parameters: RoutingParamaters) -> Bool {
        return parameters.moduleName == Self.name
    }

    public func makeRouter(use navigator: Navigator) -> IRouter {
        return routerProvider.value(navigator)
    }

}
