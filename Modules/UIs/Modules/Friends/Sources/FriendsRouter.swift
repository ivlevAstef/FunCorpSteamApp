//
//  FriendsRouter.swift
//  Friends
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Common
import SwiftLazy
import UIComponents

typealias FriendsScreen = Screen<FriendsScreenView, FriendsScreenPresenter>

final class FriendsRouter: IRouter
{
    /*dependency*/var friendsScreenProvider = Provider<FriendsScreen>()

    private let navigator: Navigator

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    func start(parameters: RoutingParamaters) {
        let screen = friendsScreenProvider.value
        configure(screen)
        navigator.push(screen.view)
    }

    private func configure(_ screen: FriendsScreen) {
        screen.setRouter(self)
    }
}
