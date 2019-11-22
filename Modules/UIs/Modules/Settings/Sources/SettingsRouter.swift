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
        let screen = settingsScreenProvider.value
        configure(screen)
        navController.setRoot(screen.view)
    }

    private func configure(_ screen: SettingsScreen) {
        screen.setRouter(self)
    }
}


