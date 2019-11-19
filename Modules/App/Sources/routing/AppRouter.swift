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

    @discardableResult
    func configure(parameters: RoutingParamaters) -> IRouter {
        let router = StartPoints.menu.makeRouter().configure(parameters: parameters)

        let startPointsCanOpened = parameters.isEmpty
            ? []
            : StartPoints.ui.values.filter { $0.isSupportOpen(with: parameters) }

        log.debug("configure first screens, use parameters finished.")
        log.trace("Params: \(parameters)")
        log.trace("Opened Start Points: \(startPointsCanOpened)")

        if startPointsCanOpened.isEmpty {
            navController.push(router, animated: false)
        } else {
            navController.pushButNotStart(router, animated: false)
        }

        log.assert(startPointsCanOpened.count <= 1, "By parameters can open more start points - it's correct, or not?")
        for startPoint in startPointsCanOpened {
            let router = startPoint.makeRouter().configure(parameters: parameters)
            navController.push(router, animated: false)
        }

        return self
    }

    private func subscribeOn(_ startPoint: MenuStartPoint) {
        StartPoints.menu.newsGetter.take(use: {
            return StartPoints.news.makeRouter().configure()
        })
        StartPoints.menu.myProfileGetter.take(use: {
            return StartPoints.profile.makeRouter().configure()
        })
//        StartPoints.menu.friendsGetter.take(use: {
//            return StartPoints.friends.makeRouter().configure()
//        })
        StartPoints.menu.settingsGetter.take(use: {
            return StartPoints.settings.makeRouter().configure()
        })
    }
}
