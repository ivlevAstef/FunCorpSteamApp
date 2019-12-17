//
//  SteamFriendData.swift
//  Storage
//
//  Created by Alexander Ivlev on 30/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Entities
import UseCases

final class SteamFriendData: Object, LimitedUpdated {
    static func generatePrimaryKey(ownerSteamId: SteamID, steamId: SteamID) -> String {
        return "\(ownerSteamId)_\(steamId)"
    }

    @objc dynamic var _ownerSteamId: String = ""
    @objc dynamic var _steamId: String = ""
    @objc dynamic var _primaryKey: String = ""

    @objc dynamic var _friendSince: Date? = nil

    @objc dynamic var lastUpdateTime: Date = Date()

    override static func primaryKey() -> String? {
        return "_primaryKey"
    }
}

extension SteamFriendData {
    convenience init(friend: SteamFriend) {
        self.init()

        _ownerSteamId = "\(friend.ownerSteamId)"
        _steamId = "\(friend.steamId)"
        _primaryKey = Self.generatePrimaryKey(ownerSteamId: friend.ownerSteamId, steamId: friend.steamId)

        _friendSince = friend.friendSince
    }

    var friend: SteamFriend? {
        guard let ownerSteamId = SteamID(_ownerSteamId), let steamId = SteamID(_steamId) else {
            return nil
        }

        return SteamFriend(ownerSteamId: ownerSteamId, steamId: steamId, friendSince: _friendSince)
    }
}
