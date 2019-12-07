//
//  DotaDependency.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 06/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity
import GameInformation //TODO: CustomGameInformation

public final class DotaDependency: DIFramework
{
    public static func load(container: DIContainer) {
        container.register(DotaRouter.init)
            .as(CustomGameInfoRouter.self)
            .injection(\.statisticsProvider)
            .lifetime(.objectGraph)

        container.register(DotaGameInfoPresenter.init)
            .lifetime(.objectGraph)

        container.register(DotaStatisticsScreen.init)
            .lifetime(.prototype)
        container.register(DotaStatisticsScreenPresenter.init)
            .lifetime(.objectGraph)
        container.register { DotaStatisticsScreenView() }
            .as(DotaStatisticsScreenViewContract.self)
            .lifetime(.objectGraph)
    }
}
