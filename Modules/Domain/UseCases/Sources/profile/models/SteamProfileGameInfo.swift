//
//  SteamProfileGameInfo.swift
//  UseCases
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Entities

public typealias SteamProfileGamesInfoResult = Result<[SteamProfileGameInfo], ServiceError>
public typealias SteamProfileGameInfoResult = Result<SteamProfileGameInfo, ServiceError>

public struct SteamProfileGameInfo
{
    public let steamId: SteamID

    public let playtimeForever: TimeInterval
    public let playtime2weeks: TimeInterval

    public let gameInfo: SteamGameInfo

    private init() { fatalError("Not support empty initialization") }
}

extension SteamProfileGameInfo
{
    public init(
        steamId: SteamID,
        playtimeForever: TimeInterval,
        playtime2weeks: TimeInterval,
        gameInfo: SteamGameInfo
    ) {
        self.steamId = steamId
        self.playtimeForever = playtimeForever
        self.playtime2weeks = playtime2weeks
        self.gameInfo = gameInfo
    }
}
