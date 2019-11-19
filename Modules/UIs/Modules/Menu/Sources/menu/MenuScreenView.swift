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

final class MenuScreenView: ApTabBarController, UITabBarControllerDelegate, MenuScreenViewContract
{
    var viewModels: [MenuViewModel] = [] {
        didSet {
            configureViewControllers()
        }
    }
    // TODO: в идеале конечно надо было поделить функционал, так чтобы экран незнал о роутере. Но это много доп. кода
    private var screensInfo: [(rootVC: ApNavigationController, router: IRouter)] = []
    private var selectedRouter: IRouter?

    override func styleDidChange(_ style: Style) {
        super.styleDidChange(style)

        tabBar.barTintColor = .red
        tabBar.tintColor = .green
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        self.delegate = self

        styleDidChange(style)
    }

    private func configureViewControllers() {
        screensInfo.removeAll()

        for viewModel in viewModels {
            if !viewModel.viewGetter.hasCallback() {
                continue
            }
            guard let router = viewModel.viewGetter.get(()) else {
                continue
            }

            let rootVC = ApNavigationController(rootViewController: router.rootViewController)
            let tag = screensInfo.count
            rootVC.tabBarItem = UITabBarItem(title: viewModel.title, image: viewModel.icon.image, tag: tag)

            screensInfo.append((rootVC: rootVC, router: router))
        }

        viewControllers = screensInfo.map { $0.rootVC }

        if let selectedVC = selectedViewController {
            select(selectedVC)
        }
    }

    private func select(_ viewController: UIViewController) {
        guard let tag = viewController.tabBarItem?.tag else {
            log.assert("Menu TabBar not contains tab bar item")
            return
        }

        select(tag)
    }

    private func select(_ index: Int) {
        if index < 0 || screensInfo.count <= index {
            log.assert("Incorrect select index - maybe need check tags")
            return
        }

        selectedRouter?.stop()
        screensInfo[index].router.start()
        selectedRouter = screensInfo[index].router
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        select(viewController)
    }
}
