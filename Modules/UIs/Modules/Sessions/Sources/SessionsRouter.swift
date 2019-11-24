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
import SwiftLazy

typealias SessionsScreen = Screen<SessionsScreenView, SessionsScreenPresenter>

final class SessionsRouter: IRouter
{
    /*dependency*/var sessionsScreenProvider = Provider<SessionsScreen>()

    var rootViewController: UIViewController {
        navController.uiController
    }

    private let navController: NavigationController

    init(navController: NavigationController) {
        self.navController = navController
    }

    func configure() -> IRouter {
        return self
    }

    func start(parameters: RoutingParamaters) {
        let screen = sessionsScreenProvider.value
        configure(screen)
        navController.setRoot(screen.view)
    }

    private func configure(_ screen: SessionsScreen) {
        screen.setRouter(self)
    }
}


