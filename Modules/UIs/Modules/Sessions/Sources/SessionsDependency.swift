//
//  SessionsDependency.swift
//  Sessions
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity

final class SessionsDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register { SessionsRouter(navigator: arg($0), authService: $1) }
            .injection(\.sessionsScreenProvider)
            .lifetime(.objectGraph)

        container.register(SessionsScreen.init)
            .lifetime(.prototype)
        container.register { SessionsScreenView() }
            .as(SessionsScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(SessionsScreenPresenter.init)
            .lifetime(.objectGraph)
    }
}
