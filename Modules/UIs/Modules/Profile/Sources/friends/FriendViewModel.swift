//
//  FriendViewModel.swift
//  Profile
//
//  Created by Alexander Ivlev on 30/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

struct FriendViewModel: Equatable
{
    struct Content: Equatable {
        let avatar: ChangeableImage
        let avatarURL: URL? // только ради сравнения
        let avatarLetter: String

        let nick: String

        let tapNotifier: Notifier<Void>

        static func ==(lhs: Content, rhs: Content) -> Bool {
            return lhs.avatarURL == rhs.avatarURL && lhs.nick == rhs.nick
        }
    }

    enum State: Equatable {
        case loading
        case failed
        case done(Content)
    }

    let steamId: SteamID
    let state: State
    let needUpdateCallback: (() -> Void)?

    static func ==(lhs: FriendViewModel, rhs: FriendViewModel) -> Bool {
        return lhs.steamId == rhs.steamId && lhs.state == rhs.state
    }
}

extension FriendViewModel
{
    init(empty state: State) {
        self.steamId = 0
        self.state = state
        self.needUpdateCallback = nil
    }
}
