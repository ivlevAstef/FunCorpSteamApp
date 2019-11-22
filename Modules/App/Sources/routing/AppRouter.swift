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

import Menu

final class AppRouter: IRouter
{
    var rootViewController: UIViewController {
        return navController.uiController
    }

    private let navController: NavigationController

    init(navController: NavigationController) {
        self.navController = navController

        self.subscribeOn(StartPoints.menu)
    }

    func start(parameters: RoutingParamaters) {
        let router = StartPoints.menu.makeRouter()
        navController.push(router, animated: false)

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

    private func subscribeOn(_ startPoint: MenuStartPoint) {
        StartPoints.menu.newsGetter.take(use: {
            return StartPoints.news.makeRouter()
        })
        StartPoints.menu.myProfileGetter.take(use: {
            return StartPoints.profile.makeRouter()
        })
//        StartPoints.menu.friendsGetter.take(use: {
//            return StartPoints.friends.makeRouter().configure()
//        })
        StartPoints.menu.settingsGetter.take(use: {
            return StartPoints.settings.makeRouter()
        })
    }
}
