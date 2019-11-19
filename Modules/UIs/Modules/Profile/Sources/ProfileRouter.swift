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

typealias AuthScreen = Screen<AuthScreenView, AuthScreenPresenter>

final class ProfileRouter: IRouter
{
    /*dependency*/var authScreenProvider = Provider<AuthScreen>()
    
    var rootViewController: UIViewController {
        let screen = authScreenProvider.value
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

    private func configure(_ screen: AuthScreen) {
        screen.setRouter(self)
    }
}
