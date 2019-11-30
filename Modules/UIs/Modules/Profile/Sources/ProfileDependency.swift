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
        container.register { ProfileRouter(navigator: arg($0), authService: $1) }
            .injection(\.profileScreenProvider)
            .injection(\.friendsScreenProvider)
            .lifetime(.objectGraph)

        container.register(ProfileScreen.init)
            .lifetime(.prototype)
        container.register { ProfileScreenView() }
            .as(ProfileScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(ProfileScreenPresenter.init)
            .lifetime(.objectGraph)

        // Вначале друзья были отдельным модулем, но потом я подумал, и решил - а зачем?
        container.register(FriendsScreen.init)
            .lifetime(.prototype)
        container.register { FriendsScreenView() }
            .as(FriendsScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(FriendsScreenPresenter.init)
            .lifetime(.objectGraph)
    }
}
