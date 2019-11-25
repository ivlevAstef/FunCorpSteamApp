//
//  FriendsDependency.swift
//  Friends
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity

final class FriendsDependency: DIFramework
{
    static func load(container: DIContainer) {
        container.register { FriendsRouter(navigator: arg($0)) }
            .injection(\.friendsScreenProvider)
            .lifetime(.objectGraph)

        container.register(FriendsScreen.init)
            .lifetime(.prototype)
        container.register { FriendsScreenView(nibName: nil, bundle: nil) }
            .as(FriendsScreenViewContract.self)
            .lifetime(.objectGraph)
        container.register(FriendsScreenPresenter.init)
            .lifetime(.objectGraph)
    }
}
