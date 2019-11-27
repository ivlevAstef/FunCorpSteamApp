//
//  StorageDependency.swift
//  Storage
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity
import Services

final class StorageDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register(SteamAuthStorageImpl.init)
            .as(SteamAuthStorage.self)
            .lifetime(.prototype)

        container.register(SteamProfileStorageImpl.init)
            .as(SteamProfileStorage.self)
            .lifetime(.prototype)

        container.register(SteamGameStorageImpl.init)
            .as(SteamGameStorage.self)
            .lifetime(.prototype)
    }
}

