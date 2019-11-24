//
//  AuthRouter.swift
//  Auth
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Common
import SwiftLazy
import UIComponents
import Services

typealias AuthScreen = Screen<AuthScreenView, AuthScreenPresenter>

final class AuthRouter: IRouter
{
    let authSuccessNotifier = Notifier<RoutingParamaters>()

    /*dependency*/var authScreenProvider = Provider<AuthScreen>()
    
    var rootViewController: UIViewController {
        return navController.uiController
    }

    private let navController: NavigationController
    private let authService: SteamAuthService
    
    init(navController: NavigationController, authService: SteamAuthService) {
        self.navController = navController
        self.authService = authService
    }

    func start(parameters: RoutingParamaters) {
        log.assert(!authService.isLogined, "Unsupport show auth if your logined")

        showAuthScreen(parameters: parameters)
    }

    private func showAuthScreen(parameters: RoutingParamaters) {
        let screen = authScreenProvider.value
        screen.setRouter(self)
        screen.presenter.authSuccessNotifier.join(authSuccessNotifier, map: { _ in
            return parameters
        })

        navController.setRoot(screen.view)
    }
}
