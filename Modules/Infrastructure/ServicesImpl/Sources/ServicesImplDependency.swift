//
//  ServicesImplDependency.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 20/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity
import Services

final class ServicesImplDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register(ImageServiceImpl.init)
            .as(ImageService.self)
            .lifetime(.perRun(.weak))

        container.register(SteamAuthServiceImpl.init)
            .as(SteamAuthService.self)
            .lifetime(.perRun(.weak))

        container.register(SteamProfileServiceImpl.init)
            .as(SteamProfileService.self)
            .lifetime(.perRun(.weak))

        container.register(SteamProfileGamesServiceImpl.init)
            .as(SteamProfileGamesService.self)
            .lifetime(.perRun(.weak))

        container.register(SteamGameServiceImpl.init)
            .as(SteamGameService.self)
            .lifetime(.perRun(.weak))

        container.register(SteamAchievementServiceImpl.init)
            .as(SteamAchievementService.self)
            .lifetime(.perRun(.weak))

        container.register(SteamFriendsServiceImpl.init)
            .as(SteamFriendsService.self)
            .lifetime(.perRun(.weak))

        container.register(SteamSessionsServiceImpl.init)
            .as(SteamSessionsService.self)
            .lifetime(.perRun(.weak))

        container.register(SteamDotaServiceImpl.init)
            .as(SteamDotaService.self)
            .lifetime(.perRun(.weak))
        container.register(SteamDotaServiceCalculatorImpl.init)
            .as(SteamDotaServiceCalculator.self)
            .lifetime(.prototype)

        container.register { SteamDotaHistorySynchronizer(network: $0, storage: $1, accountId: arg($2)) }
            .lifetime(.prototype)
        container.register { SteamDotaDetailsSynchronizer(network: $0, storage: $1, accountId: arg($2)) }
            .lifetime(.prototype)
        container.register(SteamDotaSynchronizers.init)
            .lifetime(.perRun(.strong))
    }
}

