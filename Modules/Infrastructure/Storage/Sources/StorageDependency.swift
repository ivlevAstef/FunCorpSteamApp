//
//  StorageDependency.swift
//  Storage
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity
import Services
import RealmSwift

final class StorageDependency: DIFramework
{
    static func load(container: DIContainer) {
        /// В силу ограничений времени, запись в БД игнорирует ошибки - то есть если не удалось сохранить, то этот факт просто проигнорируется
        /// Благо оно всегда записывается... Да и в прочем, а что еще делать? не выдавать же пользователю ошибку...
        container.register {
            try! Realm()
        }.lifetime(.perRun(.strong))

        container.register(SteamAuthStorageImpl.init)
            .as(SteamAuthStorage.self)
            .lifetime(.prototype)

        container.register(SteamProfileStorageImpl.init)
            .as(SteamProfileStorage.self)
            .lifetime(.prototype)

        container.register(SteamGameStorageImpl.init)
            .as(SteamGameStorage.self)
            .lifetime(.prototype)

        container.register(SteamSessionsStorageImpl.init)
            .as(SteamSessionsStorage.self)
            .lifetime(.prototype)
    }
}

