//
//  GameInfoRouter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Common
import SwiftLazy
import UIComponents
import Services

final class GameInfoRouter: IRouter
{
    /*dependency*/var gameInfoScreenProvider = Provider<GameInfoScreen>()

    private let navigator: Navigator

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    func start(parameters: RoutingParamaters) {
        let steamIdKey = GameInfoStartPoint.RoutingOptions.steamId
        let gameIdKey = GameInfoStartPoint.RoutingOptions.gameId

        if let steamId = parameters.options[steamIdKey].flatMap({ SteamID($0) }),
           let gameId = parameters.options[gameIdKey].flatMap({ SteamGameID($0) }) {
            showGameInfoScreen(steamId: steamId, gameId: gameId)
        } else {
            log.fatal("Unsupport show game info without steamId and game in options")
        }
    }

    private func showGameInfoScreen(steamId: SteamID, gameId: SteamGameID) {
        let screen = makeGameInfoScreen(steamId: steamId, gameId: gameId)

        navigator.push(screen.view)
    }

    private func makeGameInfoScreen(steamId: SteamID, gameId: SteamGameID) -> GameInfoScreen {
        let screen = gameInfoScreenProvider.value
        screen.setRouter(self)

        let presentersConfigurator = screen.configureRouters(navigator: navigator, steamId: steamId, gameId: gameId)
        screen.presenter.configure(steamId: steamId, gameId: gameId, presentersConfigurator: presentersConfigurator)

        return screen
    }
}
