//
//  GameInfoRouter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Common
import SwiftLazy
import UIComponents

typealias GameInfoScreen = Screen<GameInfoScreenView, GameInfoScreenPresenter>

final class GameInfoRouter: IRouter
{
    /*dependency*/var gameInfoScreenProvider = Provider<GameInfoScreen>()

    private let navigator: Navigator

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    func start(parameters: RoutingParamaters) {
        let screen = gameInfoScreenProvider.value
        configure(screen)
        navigator.push(screen.view)
    }

    private func configure(_ screen: GameInfoScreen) {
        screen.setRouter(self)
    }
}
