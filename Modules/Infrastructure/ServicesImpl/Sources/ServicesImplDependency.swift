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
        container.register(SteamAuthServiceImpl.init)
            .as(SteamAuthService.self)
            .lifetime(.perRun(.strong))
    }
}

