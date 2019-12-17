//
//  GameInfoScreen.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 07/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Common
import SwiftLazy
import UIComponents
import Entities
import UseCases

typealias EmbeddedGameInfoScreen = Screen<GameInfoScreenView, GameInfoScreenPresenter>


private /*static*/var associatedForCustomRoutersRetainKey: UInt8 = 0

/// Такое усложнение нужно, дабы поддержать возможно выделения кастомизации в полностью независимые блоки.
/// А фича такого усложнения в том, что вьюшка `GameInfoScreenView` автоматически попадает в нужные места.
class GameInfoScreen
{
    var view: GameInfoScreenView { screen.view }
    var presenter: GameInfoScreenPresenter { screen.presenter }

    private let screen: EmbeddedGameInfoScreen
    private let routerProviders: [Provider<CustomGameInfoRouter>]

    init(screen: EmbeddedGameInfoScreen, routerProviders: [Provider<CustomGameInfoRouter>]) {
        self.screen = screen
        self.routerProviders = routerProviders
    }

    func setRouter(_ router: IRouter) {
        screen.setRouter(router)
    }

    func configureRouters(navigator: Navigator, steamId: SteamID, gameId: SteamGameID) -> CustomGameInfoPresenterConfigurator {
        let customRouters = routerProviders.map { $0.value }

        var retainedRouters: [CustomGameInfoRouter] = []
        var customPresenters: [CustomGameInfoPresenter] = []
        for router in customRouters {
            let presenters = router.configure(navigator: navigator, steamId: steamId, gameId: gameId)

            if !presenters.isEmpty {
                customPresenters.append(contentsOf: presenters)
                retainedRouters.append(router)
            }
        }

        retainCustomRouters(retainedRouters)

        return CustomGameInfoPresenterConfigurator(customPresenters: customPresenters)
    }

    private func retainCustomRouters(_ routers: [CustomGameInfoRouter]) {
       // yes it's not good, but optimization all code
       objc_setAssociatedObject(view, &associatedForCustomRoutersRetainKey, routers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
