//
//  SteamGameInfo.swift
//  Services
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public struct SteamGameInfo
{
    public let gameId: SteamGameID
    public let name: String
    public let iconUrl: URL?
    public let logoUrl: URL?

    private init() { fatalError("Not support empty initialization") }
}

extension SteamGameInfo
{
    public init(
        gameId: SteamGameID,
        name: String,
        iconUrl: URL?,
        logoUrl: URL?
    ) {
        self.gameId = gameId
        self.name = name
        self.iconUrl = iconUrl
        self.logoUrl = logoUrl
    }
}
