//
//  GameInfoDependency.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity

final class GameInfoDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register { GameInfoRouter(navigator: arg($0)) }
            .injection(\.gameInfoScreenProvider)
            .lifetime(.objectGraph)

        container.register(GameInfoScreen.init)
            .lifetime(.prototype)
        container.register { GameInfoScreenView() }
            .as(GameInfoScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(GameInfoScreenPresenter.init)
            .lifetime(.objectGraph)
    }
}
