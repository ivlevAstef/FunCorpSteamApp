//
//  NewsDependency.swift
//  News
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity

final class NewsDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register(NewsRouter.init)
            .injection(\.ribbonScreenProvider)
            .lifetime(.objectGraph)

        container.register(RibbonScreen.init)
            .lifetime(.prototype)
        container.register { RibbonScreenView(nibName: nil, bundle: nil) }
            .as(RibbonScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(RibbonScreenPresenter.init)
            .lifetime(.objectGraph)
    }
}
