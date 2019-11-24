//
//  AuthDependency.swift
//  Auth
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity

final class AuthDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register(AuthRouter.init)
            .injection(\.authScreenProvider)
            .lifetime(.objectGraph)

        container.register(AuthScreen.init)
            .lifetime(.prototype)
        container.register { AuthScreenView() }
            .as(AuthScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(AuthScreenPresenter.init)
            .lifetime(.objectGraph)
    }
}
