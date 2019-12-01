//
//  SessionsRouter.swift
//  Sessions
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import UIComponents
import Common
import Services
import SwiftLazy

typealias SessionsScreen = Screen<SessionsScreenView, SessionsScreenPresenter>

final class SessionsRouter: IRouter
{
    let tapOnGameNotifier = Notifier<(SteamID, SteamGameID, Navigator)>()
    
    /*dependency*/var sessionsScreenProvider = Provider<SessionsScreen>()

    private let navigator: Navigator
    private let authService: SteamAuthService

    private var currentRoutingParamaters: RoutingParamaters?

    init(navigator: Navigator, authService: SteamAuthService) {
        self.navigator = navigator
        self.authService = authService
    }

    func start(parameters: RoutingParamaters) {
        if currentRoutingParamaters == parameters {
            return
        }
        currentRoutingParamaters = parameters

        let steamIdKey = SessionsStartPoint.RoutingOptions.steamId
        if let steamId = parameters.options[steamIdKey].flatMap({ SteamID($0) }) {
            showSessionsScreen(steamId: steamId, on: navigator)
        } else if let steamId = authService.steamId {
            showSessionsScreen(steamId: steamId, on: navigator)
        } else {
            log.fatal("Unsupport show sessions without steamId for options or auth")
        }
    }

    private func showSessionsScreen(steamId: SteamID, on navigator: Navigator) {
        let screen = sessionsScreenProvider.value
        screen.setRouter(self)

        screen.presenter.tapOnGameNotifier.join(tapOnGameNotifier) { (steamId, gameId) in
            return (steamId, gameId, navigator)
        }

        screen.presenter.configure(steamId: steamId)

        navigator.push(screen.view)
    }

}


