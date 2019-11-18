//
//  MenuDependency.swift
//  Menu
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity

final class MenuDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register(MenuRouter.init)
            .injection(\.menuScreenProvider)
            .lifetime(.objectGraph)

        container.register(MenuScreen.init)
            .lifetime(.prototype)
        container.register { MenuScreenView() }
            .as(MenuScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(MenuScreenPresenter.init)
            .lifetime(.objectGraph)
    }
}

