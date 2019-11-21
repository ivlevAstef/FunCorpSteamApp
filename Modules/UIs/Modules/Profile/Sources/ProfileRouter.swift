//
//  ProfileRouter.swift
//  Profile
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
typealias ProfileScreen = Screen<ProfileScreenView, ProfileScreenPresenter>

final class ProfileRouter: IRouter
{
    /*dependency*/var authScreenProvider = Provider<AuthScreen>()
    /*dependency*/var profileScreenProvider = Provider<ProfileScreen>()
    
    var rootViewController: UIViewController {
        return navController.uiController
    }

    private let navController: NavigationController
    private let authService: SteamAuthService
    
    init(navController: NavigationController, authService: SteamAuthService) {
        self.navController = navController
        self.authService = authService
    }
    
    func configure(parameters: RoutingParamaters) -> IRouter {
        let steamIdKey = ProfileStartPoint.RoutingOptions.steamId
        if let steamId = parameters.options[steamIdKey].flatMap({ SteamID($0) }) {
            showProfileScreen(steamId: steamId)
        } else {
            showRootScreen()
        }

        return self
    }

    func start() {

    }

    private func showRootScreen() {
        let showView: UIViewController
        if authService.isLogined, let steamId = authService.steamId {
            showView = makeProfileScreen(steamId: steamId).view
        } else {
            showView = makeAuthScreen().view
        }

        navController.setRoot(showView)
    }

    private func showProfileScreen(steamId: SteamID) {
        let screen = makeProfileScreen(steamId: steamId)

        navController.setRoot(screen.view)
    }

    private func makeAuthScreen() -> AuthScreen {
        let screen = authScreenProvider.value
        screen.setRouter(self)

        screen.presenter.authSuccessNotifier.join(listener: { [weak self] in
            self?.showRootScreen()
        })
        return screen
    }

    private func makeProfileScreen(steamId: SteamID) -> ProfileScreen {
        let screen = profileScreenProvider.value
        screen.setRouter(self)

        screen.presenter.configure(steamId: steamId)
        return screen
    }
}
