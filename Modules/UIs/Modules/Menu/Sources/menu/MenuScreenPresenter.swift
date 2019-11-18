//
//  MenuScreenPresenter.swift
//  Menu
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

protocol MenuScreenViewContract: class
{
    var viewModels: [MenuViewModel] { get set }
}

final class MenuScreenPresenter
{
    let showNews = Notifier<Void>()
    let showMyProfile = Notifier<Void>()
    let showFriends = Notifier<Void>()
    let showSettings = Notifier<Void>()

    private let view: MenuScreenViewContract

    init(view: MenuScreenViewContract) {
        self.view = view

        configure()
    }

    private func configure() {
        view.viewModels = [
            MenuViewModel(
                icon: ConstImage(image: nil),
                title: "News",
                show: showNews
            ),
            MenuViewModel(
                icon: ConstImage(image: nil),
                title: "MyProfile",
                show: showMyProfile
            ),
            MenuViewModel(
                icon: ConstImage(image: nil),
                title: "Friends",
                show: showFriends
            ),
            MenuViewModel(
                icon: ConstImage(image: nil),
                title: "Settings",
                show: showSettings
            ),
        ]
    }
}
