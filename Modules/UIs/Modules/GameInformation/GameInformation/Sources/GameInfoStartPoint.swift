//
//  GameInfoStartPoint.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity
import SwiftLazy
import Entities

public final class GameInfoStartPoint: UIStartPoint
{
    public enum RoutingOptions {
        public static let steamId = "SteamId"
        public static let gameId = "GameId"
    }

    public static let name: UIModuleName = .gameInfo

    private var routerProvider = Provider1<GameInfoRouter, Navigator>()

    public init() {

    }

    public func makeParams(steamId: SteamID, gameId: SteamGameID) -> RoutingParamaters {
        return RoutingParamaters(moduleName: Self.name, options: [
            RoutingOptions.steamId: "\(steamId)",
            RoutingOptions.gameId: "\(gameId)"
        ])
    }
    
    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: GameInfoDependency.self)
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
