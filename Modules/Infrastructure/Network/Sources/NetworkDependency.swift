//
//  NetworkDependency.swift
//  Network
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity
import Services

final class NetworkDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register(NetworkSession.init)
            .lifetime(.perRun(.strong))

        container.register(SteamAuthNetworkImpl.init)
            .as(SteamAuthNetwork.self)
            .lifetime(.prototype)

        container.register(SteamProfileNetworkImpl.init)
            .as(SteamProfileNetwork.self)
            .lifetime(.prototype)

        container.register(SteamGameNetworkImpl.init)
            .as(SteamGameNetwork.self)
            .lifetime(.prototype)
    }
}

