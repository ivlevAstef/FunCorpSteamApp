//
//  SteamGameAchievementProgress.swift
//  Services
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public typealias SteamAchievementID = String
public typealias SteamStatID = String

public typealias SteamGameProgressResult = Result<SteamGameProgress, ServiceError>
public typealias SteamGameProgressHistoryResult = Result<[SteamGameProgress], ServiceError>

public struct SteamGameProgress
{
    public struct Achievement {
        public let achieved: Bool
        public let unlocktime: Date?

        private init() { fatalError("Not support empty initialization") }
    }

    public struct Stat {
        public let count: Int

        private init() { fatalError("Not support empty initialization") }
    }

    public let gameId: SteamGameID
    public let achievements: [SteamAchievementID: Achievement]
    public let stats: [SteamStatID: Stat]
    /// Дата когда было такое состояние прогресса
    public let stateDate: Date

    private init() { fatalError("Not support empty initialization") }
}

extension SteamGameProgress
{
    public init(
        gameId: SteamGameID,
        achievements: [SteamAchievementID: Achievement],
        stats: [SteamStatID: Stat],
        stateDate: Date
    ) {
        self.gameId = gameId
        self.achievements = achievements
        self.stats = stats
        self.stateDate = stateDate
    }
}

extension SteamGameProgress.Achievement
{
    public init(achieved: Bool, unlocktime: Date?) {
        self.achieved = achieved
        self.unlocktime = unlocktime
    }
}

extension SteamGameProgress.Stat
{
    public init(count: Int) {
        self.count = count
    }
}
