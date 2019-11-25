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
    let newsGetter = Getter<Navigator, IRouter>()
    let myProfileGetter = Getter<Navigator, IRouter>()
    let sessionsGetter = Getter<Navigator, IRouter>()

    /*dependency*/var menuScreenProvider = Lazy<MenuScreen>()

    private let navigator: Navigator

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    func start(parameters: RoutingParamaters) {
        let screen = menuScreenProvider.value
        configure(screen)

        navigator.push(screen.view)
    }

    private func configure(_ screen: MenuScreen) {
        screen.setRouter(self)
        
        screen.presenter.newsGetter.take(from: self.newsGetter)
        screen.presenter.myProfileGetter.take(from: self.myProfileGetter)
        screen.presenter.sessionsGetter.take(from: self.sessionsGetter)

        screen.presenter.start()
    }
}
