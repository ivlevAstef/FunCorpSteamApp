//
//  AppRouter.swift
//  ApLife
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Common
import UIComponents
import Services

import Auth
import Menu

import Profile
import GameInformation

final class AppRouter: IRouter
{
    var rootViewController: UIViewController {
        return navigator.controller
    }

    private let navigator: Navigator
    private let authService: SteamAuthService

    init(navigator: Navigator, authService: SteamAuthService) {
        self.navigator = navigator
        self.authService = authService

        navigator.showNavigationBar = false

        StartPoints.auth.subscribersFiller = subscriberFiller
        StartPoints.menu.subscribersFiller = subscriberFiller

        StartPoints.profile.subscribersFiller = subscriberFiller
    }

    func start(parameters: RoutingParamaters) {
        showRoot(parameters: parameters)
    }

    private func showRoot(parameters: RoutingParamaters) {
        navigator.reset()
        if !authService.isLogined {
            showAuth(parameters: parameters)
        } else {
            showMenu(parameters: parameters)
        }
    }

    private func showAuth(parameters: RoutingParamaters) {
        let router = StartPoints.auth.makeRouter(use: navigator)

        router.start(parameters: parameters)
    }

    private func showMenu(parameters: RoutingParamaters) {
        let router = StartPoints.menu.makeRouter(use: navigator)

        let startPointsCanOpened = parameters.isEmpty
            ? []
            : StartPoints.ui.values.filter { $0.isSupportOpen(with: parameters) }

        if startPointsCanOpened.isEmpty {
            router.start()
        }

        log.assert(startPointsCanOpened.count <= 1, "By parameters can open more start points - it's correct, or not?")
        for startPoint in startPointsCanOpened {
            let router = startPoint.makeRouter(use: navigator)
            router.start(parameters: parameters)
        }
    }

    private func subscriberFiller(_ navigator: Navigator, subscribers: AuthStartPoint.Subscribers) {
        subscribers.authSuccessNotifier.join(listener: { [weak self] parameters in
            self?.showRoot(parameters: parameters)
        })
    }

    private func subscriberFiller(_ navigator: Navigator, subscribers: MenuStartPoint.Subscribers) {
        subscribers.newsGetter.take(use: { navigator in
            return StartPoints.news.makeRouter(use: navigator)
        })
        subscribers.myProfileGetter.take(use: { navigator in
            return StartPoints.profile.makeRouter(use: navigator)
        })
        subscribers.sessionsGetter.take(use: { navigator in
            return StartPoints.sessions.makeRouter(use: navigator)
        })
    }

    private func subscriberFiller(_ navigator: Navigator, subscribers: ProfileStartPoint.Subscribers) {
        subscribers.tapOnGameNotifier.join(listener: { (steamId, gameId, navigator) in
            let router = StartPoints.gameInfo.makeRouter(use: navigator)
            router.start(parameters: StartPoints.gameInfo.makeParams(steamId: steamId, gameId: gameId))
        })
    }
}
