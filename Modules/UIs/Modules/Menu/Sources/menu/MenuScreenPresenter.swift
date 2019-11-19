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
    let newsGetter = Getter<Void, IRouter>()
    let myProfileGetter = Getter<Void, IRouter>()
    let friendsGetter = Getter<Void, IRouter>()
    let settingsGetter = Getter<Void, IRouter>()

    private let view: MenuScreenViewContract

    init(view: MenuScreenViewContract) {
        self.view = view
    }

    func start() {
        configure()
    }

    private func configure() {
        view.viewModels = [
            MenuViewModel(
                icon: ConstImage(image: nil),
                title: "News",
                viewGetter: newsGetter
            ),
            MenuViewModel(
                icon: ConstImage(image: nil),
                title: "MyProfile",
                viewGetter: myProfileGetter
            ),
            MenuViewModel(
                icon: ConstImage(image: nil),
                title: "Friends",
                viewGetter: friendsGetter
            ),
            MenuViewModel(
                icon: ConstImage(image: nil),
                title: "Settings",
                viewGetter: settingsGetter
            ),
        ]
    }
}
