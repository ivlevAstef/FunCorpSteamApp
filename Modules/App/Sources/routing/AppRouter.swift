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
        return navController.uiController
    }

    private let navController: NavigationController
    private let authService: SteamAuthService

    init(navController: NavigationController, authService: SteamAuthService) {
        self.navController = navController
        self.authService = authService

        self.subscribeOn(StartPoints.auth)
        self.subscribeOn(StartPoints.menu)
    }

    func start(parameters: RoutingParamaters) {
        showRoot(parameters: parameters)
    }

    private func showRoot(parameters: RoutingParamaters) {
        if !authService.isLogined {
            showAuth(parameters: parameters)
        } else {
            showMenu(parameters: parameters)
        }
    }

    private func showAuth(parameters: RoutingParamaters) {
        let router = StartPoints.auth.makeRouter()
        navController.setRoot(router)

        router.start(parameters: parameters)
    }

    private func showMenu(parameters: RoutingParamaters) {
        let router = StartPoints.menu.makeRouter()
        navController.setRoot(router)

        let startPointsCanOpened = parameters.isEmpty
            ? []
            : StartPoints.ui.values.filter { $0.isSupportOpen(with: parameters) }

        if startPointsCanOpened.isEmpty {
            router.start()
        }

        log.assert(startPointsCanOpened.count <= 1, "By parameters can open more start points - it's correct, or not?")
        for startPoint in startPointsCanOpened {
            let router = startPoint.makeRouter()
            navController.push(router, animated: false)
            router.start(parameters: parameters)
        }
    }

    private func subscribeOn(_ startPoint: AuthStartPoint) {
        startPoint.authSuccessNotifier.join(listener: { [weak self] parameters in
            self?.showRoot(parameters: parameters)
        })
    }

    private func subscribeOn(_ startPoint: MenuStartPoint) {
        startPoint.newsGetter.take(use: {
            return StartPoints.news.makeRouter()
        })
        startPoint.myProfileGetter.take(use: {
            return StartPoints.profile.makeRouter()
        })
        startPoint.sessionsGetter.take(use: {
            return StartPoints.sessions.makeRouter()
        })
    }
}
