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

        self.subscribeOn(StartPoints.auth)
        self.subscribeOn(StartPoints.menu)
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

    private func subscribeOn(_ startPoint: AuthStartPoint) {
        startPoint.authSuccessNotifier.join(listener: { [weak self] parameters in
            self?.showRoot(parameters: parameters)
        })
    }

    private func subscribeOn(_ startPoint: MenuStartPoint) {
        startPoint.newsGetter.take(use: { navigator in
            return StartPoints.news.makeRouter(use: navigator)
        })
        startPoint.myProfileGetter.take(use: { navigator in
            return StartPoints.profile.makeRouter(use: navigator)
        })
        startPoint.sessionsGetter.take(use: { navigator in
            return StartPoints.sessions.makeRouter(use: navigator)
        })
    }
}
