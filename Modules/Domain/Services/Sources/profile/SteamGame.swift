//
//  SteamProfileGame.swift
//  Services
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public typealias SteamProfileGamesResult = Result<[SteamProfileGame], ServiceError>

public struct SteamProfileGame {
    public let steamId: SteamID
    public let appId: Int64
    public let name: String
    public let iconUrl: URL?
    public let logoUrl: URL?

    public let playtimeForever: TimeInterval
    public let playtime2weeks: TimeInterval

    private init() { fatalError("Not support empty initialization") }
}

extension SteamProfileGame {
    public init(
        steamId: SteamID,
        appId: Int64,
        name: String,
        iconUrl: URL?,
        logoUrl: URL?,
        playtimeForever: TimeInterval,
        playtime2weeks: TimeInterval
    ) {
        self.steamId = steamId
        self.appId = appId
        self.name = name
        self.iconUrl = iconUrl
        self.logoUrl = logoUrl
        self.playtimeForever = playtimeForever
        self.playtime2weeks = playtime2weeks
    }
}
