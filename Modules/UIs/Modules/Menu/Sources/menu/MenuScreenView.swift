//
//  MenuScreenView.swift
//  Menu
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Common
import UIComponents
import Design
import SwiftLazy

final class MenuScreenView: ApTabBarController, UITabBarControllerDelegate, MenuScreenViewContract
{
    var viewModels: [MenuViewModel] = [] {
        didSet {
            configureViewControllers()
        }
    }

    private let navigatorProvider: Provider<Navigator>

    init(navigatorProvider: Provider<Navigator>) {
        self.navigatorProvider = navigatorProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func styleDidChange(_ style: Style) {
        super.styleDidChange(style)

        tabBar.barStyle = style.colors.barStyle
        tabBar.tintColor = style.colors.tint
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        styleDidChange(style)
    }

    private func configureViewControllers() {
        var selectedIndex: Int = 0
        var newViewControllers: [UIViewController] = []
        for viewModel in viewModels {
            if !viewModel.viewGetter.hasCallback() {
                continue
            }

            let navigator = navigatorProvider.value
            guard let router = viewModel.viewGetter.get(navigator) else {
                continue
            }
            router.start()

            let vc = navigator.controller
            vc.tabBarItem = UITabBarItem(title: viewModel.title, image: viewModel.icon.image, tag: 0)

            if viewModel.selected {
                selectedIndex = newViewControllers.count
            }

            newViewControllers.append(vc)
        }

        viewControllers = newViewControllers
        self.selectedIndex = selectedIndex
    }
}
