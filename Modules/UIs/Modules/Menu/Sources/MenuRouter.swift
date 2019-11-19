//
//  MenuRouter.swift
//  Menu
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import UIKit
import Core
import UIComponents
import Common
import SwiftLazy


typealias MenuScreen = Screen<MenuScreenView, MenuScreenPresenter>

final class MenuRouter: IRouter
{
    let newsGetter = Getter<Void, IRouter>()
    let myProfileGetter = Getter<Void, IRouter>()
    let friendsGetter = Getter<Void, IRouter>()
    let settingsGetter = Getter<Void, IRouter>()

    /*dependency*/var menuScreenProvider = Provider<MenuScreen>()
    
    var rootViewController: UIViewController {
        let screen = menuScreenProvider.value
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
//        log.info("will show blog")
//        if let blogRouter = blogGetter.get(()) {
//            navController.push(blogRouter, animated: false)
//            log.info("did show blog")
//        }
    }

    private func configure(_ screen: MenuScreen) {
        screen.setRouter(self)
        
        screen.presenter.newsGetter.take(from: self.newsGetter)
        screen.presenter.myProfileGetter.take(from: self.myProfileGetter)
        screen.presenter.friendsGetter.take(from: self.friendsGetter)
        screen.presenter.settingsGetter.take(from: self.settingsGetter)

        screen.presenter.start()
    }
}
