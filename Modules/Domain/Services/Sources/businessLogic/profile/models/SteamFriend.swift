//
//  SteamFriend.swift
//  Services
//
//  Created by Alexander Ivlev on 30/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public typealias SteamFriendsResult = Result<[SteamFriend], ServiceError>

public struct SteamFriend: Equatable
{
    public let ownerSteamId: SteamID

    public let steamId: SteamID
    public let friendSince: Date?

    private init() { fatalError("Not support empty initialization") }
}

extension SteamFriend
{
    public init(
        ownerSteamId: SteamID,
        steamId: SteamID,
        friendSince: Date?
    ) {
        self.ownerSteamId = ownerSteamId
        self.steamId = steamId
        self.friendSince = friendSince
    }
}
