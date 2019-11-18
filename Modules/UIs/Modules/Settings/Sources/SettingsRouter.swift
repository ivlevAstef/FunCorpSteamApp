//
//  SettingsRouter.swift
//  Settings
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import UIComponents
import Common
import SwiftLazy


typealias SettingsScreen = Screen<SettingsScreenView, SettingsScreenPresenter>

final class SettingsRouter: IRouter
{
    /*dependency*/var settingsScreenProvider = Provider<SettingsScreen>()

    var rootViewController: UIViewController {
        let screen = settingsScreenProvider.value
        configure(screen)
        return screen.view
    }

    private let navController: NavigationController

    init(navController: NavigationController) {
        self.navController = navController
    }

    func configure(parameters: RoutingParamaters) -> IRouter {
        return self
    }

    func start() {
    }

    private func configure(_ screen: SettingsScreen) {
        screen.setRouter(self)
    }
}


