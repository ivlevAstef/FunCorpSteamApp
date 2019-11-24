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
import AppUIComponents
import UIComponents
import Services

typealias ProfileScreen = Screen<ProfileScreenView, ProfileScreenPresenter>

final class ProfileRouter: IRouter
{
    /*dependency*/var profileScreenProvider = Provider<ProfileScreen>()
    
    var rootViewController: UIViewController {
        return navController.uiController
    }

    private let navController: NavigationController & SteamNavigationController
    private let authService: SteamAuthService

    private var currentRoutingParamaters: RoutingParamaters?
    
    init(navController: NavigationController & SteamNavigationController, authService: SteamAuthService) {
        self.navController = navController
        self.authService = authService
    }

    func start(parameters: RoutingParamaters) {
        if currentRoutingParamaters == parameters {
            return
        }
        // TODO: currentRoutingParamaters = parameters

        let steamIdKey = ProfileStartPoint.RoutingOptions.steamId
        if let steamId = parameters.options[steamIdKey].flatMap({ SteamID($0) }) {
            navController.setSteamId(steamId)
            showProfileScreen(steamId: steamId)
        } else if let steamId = authService.steamId {
            navController.setSteamId(steamId)
            showProfileScreen(steamId: steamId)
        } else {
            log.fatal("Unsupport show profile without steamId for options or auth")
        }
    }

    private func showProfileScreen(steamId: SteamID) {
        let screen = makeProfileScreen(steamId: steamId)

        navController.setRoot(screen.view)
    }

    private func makeProfileScreen(steamId: SteamID) -> ProfileScreen {
        let screen = profileScreenProvider.value
        screen.setRouter(self)

        screen.presenter.configure(steamId: steamId)
        return screen
    }
}
