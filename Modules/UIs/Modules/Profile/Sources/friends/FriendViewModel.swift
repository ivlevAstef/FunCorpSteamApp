//
//  FriendViewModel.swift
//  Profile
//
//  Created by Alexander Ivlev on 30/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Services

struct FriendViewModel
{
    struct Content {
        let avatar: ChangeableImage
        let avatarLetter: String

        let nick: String

        let tapNotifier: Notifier<Void>
    }

    enum State {
        case loading
        case failed
        case done(Content)
    }

    let steamId: SteamID
    let state: State
    let needUpdateCallback: (() -> Void)?
}

extension FriendViewModel
{
    init(empty state: State) {
        self.steamId = 0
        self.state = state
        self.needUpdateCallback = nil
    }
}
