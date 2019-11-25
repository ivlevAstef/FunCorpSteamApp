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
    let tapOnProfileNotifier = Notifier<SteamID>()
    let tapOnGameNotifier = Notifier<(SteamID, SteamGameID)>()

    /*dependency*/var profileScreenProvider = Provider<ProfileScreen>()

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

        let steamIdKey = ProfileStartPoint.RoutingOptions.steamId
        if let steamId = parameters.options[steamIdKey].flatMap({ SteamID($0) }) {
            showProfileScreen(steamId: steamId)
        } else if let steamId = authService.steamId {
            showProfileScreen(steamId: steamId)
        } else {
            log.fatal("Unsupport show profile without steamId for options or auth")
        }
    }

    private func showProfileScreen(steamId: SteamID) {
        let screen = makeProfileScreen(steamId: steamId)

        navigator.push(screen.view)
    }

    private func makeProfileScreen(steamId: SteamID) -> ProfileScreen {
        let screen = profileScreenProvider.value
        screen.setRouter(self)

        screen.presenter.tapOnProfileNotifier.join(tapOnProfileNotifier)
        screen.presenter.tapOnGameNotifier.join(tapOnGameNotifier)

        screen.presenter.configure(steamId: steamId)
        return screen
    }
}
