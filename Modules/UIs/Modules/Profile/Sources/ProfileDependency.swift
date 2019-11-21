//
//  ProfileDependency.swift
//  Profile
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity

final class ProfileDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register(ProfileRouter.init)
            .injection(\.authScreenProvider)
            .injection(\.profileScreenProvider)
            .lifetime(.objectGraph)

        container.register(AuthScreen.init)
            .lifetime(.prototype)
        container.register { AuthScreenView() }
            .as(AuthScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(AuthScreenPresenter.init)
            .lifetime(.objectGraph)

        container.register(ProfileScreen.init)
            .lifetime(.prototype)
        container.register { ProfileScreenView() }
            .as(ProfileScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(ProfileScreenPresenter.init)
            .lifetime(.objectGraph)
    }
}
