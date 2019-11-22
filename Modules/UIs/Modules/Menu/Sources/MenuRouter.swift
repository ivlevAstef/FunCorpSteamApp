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

    /*dependency*/var menuScreenProvider = Lazy<MenuScreen>()
    
    var rootViewController: UIViewController {
        return menuScreenProvider.value.view
    }

    init() {
    }

    func start(parameters: RoutingParamaters) {
        let screen = menuScreenProvider.value
        configure(screen)
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
