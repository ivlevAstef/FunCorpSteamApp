//
//  MenuScreenPresenter.swift
//  Menu
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import Common

protocol MenuScreenViewContract: class
{
    var viewModels: [MenuViewModel] { get set }
}

final class MenuScreenPresenter
{
    let newsGetter = Getter<Navigator, IRouter>()
    let myProfileGetter = Getter<Navigator, IRouter>()
    let sessionsGetter = Getter<Navigator, IRouter>()

    private weak var view: MenuScreenViewContract?

    init(view: MenuScreenViewContract) {
        self.view = view
    }

    func start() {
        configure()
    }

    private func configure() {
        view?.viewModels = [
            MenuViewModel(
                icon: ConstImage(named: "tabbarNews"),
                title: loc["SteamMenu.News"],
                selected: false,
                viewGetter: newsGetter
            ),
            MenuViewModel(
                icon: ConstImage(named: "tabbarProfile"),
                title: loc["SteamMenu.Profile"],
                selected: true,
                viewGetter: myProfileGetter
            ),
            MenuViewModel(
                icon: ConstImage(named: "tabbarSessions"),
                title: loc["SteamMenu.Sessions"],
                selected: false,
                viewGetter: sessionsGetter
            ),
        ]
    }
}
