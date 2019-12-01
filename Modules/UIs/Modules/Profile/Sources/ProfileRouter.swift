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
typealias FriendsScreen = Screen<FriendsScreenView, FriendsScreenPresenter>

final class ProfileRouter: IRouter
{
    let tapOnGameNotifier = Notifier<(SteamID, SteamGameID, Navigator)>()

    /*dependency*/var profileScreenProvider = Provider<ProfileScreen>()
    /*dependency*/var friendsScreenProvider = Provider<FriendsScreen>()

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
            showProfileScreen(steamId: steamId, on: navigator)
        } else if let steamId = authService.steamId {
            showProfileScreen(steamId: steamId, on: navigator)
        } else {
            log.fatal("Unsupport show profile without steamId for options or auth")
        }
    }

    // MARK: - profile

    private func showProfileScreen(steamId: SteamID, on navigator: Navigator) {
        let screen = makeProfileScreen(steamId: steamId, use: navigator)

        navigator.push(screen.view)
    }

    private func presentProfileScreen(steamId: SteamID, on navigator: Navigator) {
        // При первом показе показываем present, а все остальные пушом.
        // Дабы была возможность легко закрыть всех друзей, ну и лагов не было из-за кучи present на ios13
        if nil == self.navigator.controller.presentedViewController {
            let presentedNavigator = navigator.copy()
            let screen = makeProfileScreen(steamId: steamId, use: presentedNavigator)
            presentedNavigator.push(screen.view)

            navigator.present(presentedNavigator.controller)
        } else {
            let screen = makeProfileScreen(steamId: steamId, use: navigator)
            navigator.push(screen.view)
        }
    }

    private func makeProfileScreen(steamId: SteamID, use navigator: Navigator) -> ProfileScreen {
        let screen = profileScreenProvider.value
        screen.setRouter(self)

        screen.presenter.tapOnProfileNotifier.join(listener: { [weak self, navigator] steamId in
            self?.showFriendsScreen(for: steamId, on: navigator)
        })
        screen.presenter.tapOnGameNotifier.join(tapOnGameNotifier) { (steamId, gameId) in
            return (steamId, gameId, navigator)
        }

        screen.presenter.configure(steamId: steamId)
        return screen
    }

    // MARK: - friends

    private func showFriendsScreen(for steamId: SteamID, on navigator: Navigator) {
        let screen = makeFriendsScreen(for: steamId, use: navigator)

        navigator.push(screen.view)
    }

    private func makeFriendsScreen(for steamId: SteamID, use navigator: Navigator) -> FriendsScreen {
        let screen = friendsScreenProvider.value
        screen.setRouter(self)

        screen.presenter.tapOnProfileNotifier.join(listener: { [weak self, navigator] steamId in
            self?.presentProfileScreen(steamId: steamId, on: navigator)
        })

        screen.presenter.configure(steamId: steamId)
        return screen
    }

}
