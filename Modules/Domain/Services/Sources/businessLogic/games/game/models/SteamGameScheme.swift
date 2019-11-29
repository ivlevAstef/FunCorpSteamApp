//
//  SteamGameScheme.swift
//  Services
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public typealias SteamGameSchemeResult = Result<SteamGameScheme, ServiceError>

public struct SteamGameScheme
{
    public struct Achivement {
        public let id: SteamAchievementID
        public let hidden: Bool

        public let localizedName: String
        public let localizedDescription: String

        public let iconUrl: URL?
        public let iconGrayUrl: URL?

        private init() { fatalError("Not support empty initialization") }
    }

    public struct Stat {
        public let id: SteamStatID
        public let localizedName: String

        private init() { fatalError("Not support empty initialization") }
    }

    public let gameId: SteamGameID

    public let achivements: [Achivement]
    public let stats: [Stat]

    private init() { fatalError("Not support empty initialization") }
}

extension SteamGameScheme
{
    public init(
        gameId: SteamGameID,
        achivements: [Achivement],
        stats: [Stat]
    ) {
        self.gameId = gameId
        self.achivements = achivements
        self.stats = stats
    }
}

extension SteamGameScheme.Achivement
{
    public init(
        id: String,
        hidden: Bool,
        localizedName: String,
        localizedDescription: String,
        iconUrl: URL?,
        iconGrayUrl: URL?
    ) {
        self.id = id
        self.hidden = hidden
        self.localizedName = localizedName
        self.localizedDescription = localizedDescription
        self.iconUrl = iconUrl
        self.iconGrayUrl = iconGrayUrl
    }
}

extension SteamGameScheme.Stat
{
    public init(
        id: String,
        localizedName: String
    ) {
        self.id = id
        self.localizedName = localizedName
    }
}
