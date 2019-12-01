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

        container.register { GameInfoScreenView(cellConfigurator: $0) }
            .as(GameInfoScreenViewContract.self)
            .as(CustomGameInfoViewContract.self)
            .lifetime(.objectGraph)

        container.register(GameInfoScreenPresenter.init)
            .lifetime(.objectGraph)

        // MARK: - customs
        container.register {
            CustomGameInfoPresenterConfigurator(view: $0, customPresenters: many($1))
        }.lifetime(.objectGraph)

        container.register {
            CustomTableCellConfiguratorComposite(configurators: many($0))
        }.lifetime(.prototype)

        // MARK: - dota
        container.register(DotaGameInfoPresenter.init)
            .as(CustomGameInfoPresenter.self)
            .lifetime(.objectGraph)
        container.register(DotaTableCellConfigurator.init)
            .as(CustomTableCellConfigurator.self)
            .lifetime(.prototype)
    }
}
