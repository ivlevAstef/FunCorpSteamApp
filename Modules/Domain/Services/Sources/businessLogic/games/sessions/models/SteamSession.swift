//
//  SteamSession.swift
//  Services
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public typealias SteamSessionsResult = Result<[SteamSession], ServiceError>

public struct SteamSession
{
    public let gameInfo: SteamGameInfo

    public let playtimeForever: TimeInterval
    public let playtime2weeks: TimeInterval

    private init() { fatalError("Not support empty initialization") }
}

extension SteamSession
{
    public init(gameInfo: SteamGameInfo,
                playtimeForever: TimeInterval,
                playtime2weeks: TimeInterval) {
        self.gameInfo = gameInfo
        self.playtimeForever = playtimeForever
        self.playtime2weeks = playtime2weeks
    }
}
