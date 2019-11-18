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
        
        // TODO: Can use `getter.hasCallback()` for configure menu...
        screen.presenter.showNews.weakJoin(listener: { (self, showParams) in
            self.showScreen(use: self.newsGetter)
        }, owner: self)
        screen.presenter.showMyProfile.weakJoin(listener: { (self, showParams) in
            self.showScreen(use: self.myProfileGetter)
        }, owner: self)
        screen.presenter.showFriends.weakJoin(listener: { (self, showParams) in
            self.showScreen(use: self.friendsGetter)
        }, owner: self)
        screen.presenter.showSettings.weakJoin(listener: { (self, showParams) in
            self.showScreen(use: self.settingsGetter)
        }, owner: self)
    }

    private func showScreen(use getter: Getter<Void, IRouter>) {
        log.info("will show \(getter)")
        guard let router = getter.get(()) else {
            log.info("Not support show \(getter)")
            return
        }

        navController.push(router, animated: true)
        log.info("did show \(getter)")
    }
}

