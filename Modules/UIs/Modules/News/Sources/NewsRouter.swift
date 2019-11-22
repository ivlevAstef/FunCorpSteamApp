//
//  NewsRouter.swift
//  News
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Common
import SwiftLazy
import UIComponents

typealias RibbonScreen = Screen<RibbonScreenView, RibbonScreenPresenter>

final class NewsRouter: IRouter
{
    /*dependency*/var ribbonScreenProvider = Provider<RibbonScreen>()
    
    var rootViewController: UIViewController {
        return navController.uiController
    }

    private let navController: NavigationController
    
    init(navController: NavigationController) {
        self.navController = navController
    }

    func start(parameters: RoutingParamaters) {
        let screen = ribbonScreenProvider.value
        configure(screen)
        navController.setRoot(screen.view)
    }

    private func configure(_ screen: RibbonScreen) {
        screen.setRouter(self)
    }
}
