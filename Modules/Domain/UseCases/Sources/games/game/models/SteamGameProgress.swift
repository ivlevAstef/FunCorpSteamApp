//
//  SteamGameAchievementProgress.swift
//  UseCases
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Entities

public typealias SteamGameProgressResult = Result<SteamGameProgress, ServiceError>
public typealias SteamGameProgressHistoryCompletion = Result<[SteamGameProgress], ServiceError>

public struct SteamGameProgress: Equatable
{
    public struct Achievement: Equatable {
        public let achieved: Bool

        private init() { fatalError("Not support empty initialization") }
    }

    public struct Stat: Equatable {
        public let count: Double

        private init() { fatalError("Not support empty initialization") }
    }

    public let gameId: SteamGameID
    public let achievements: [SteamAchievementID: Achievement]
    public let stats: [SteamStatID: Stat]
    /// Начальное время когда точно было такое состояние прогресса
    public let stateDateBegin: Date
    /// Конечное время когда точно было такое состояние прогресса
    public let stateDateEnd: Date

    private init() { fatalError("Not support empty initialization") }

    public static func ==(lhs: SteamGameProgress, rhs: SteamGameProgress) -> Bool {
        return lhs.gameId == rhs.gameId && lhs.achievements == rhs.achievements && lhs.stats == rhs.stats
    }
}

extension SteamGameProgress
{
    public init(
        gameId: SteamGameID,
        achievements: [SteamAchievementID: Achievement],
        stats: [SteamStatID: Stat],
        stateDateBegin: Date,
        stateDateEnd: Date
    ) {
        self.gameId = gameId
        self.achievements = achievements
        self.stats = stats
        self.stateDateBegin = stateDateBegin
        self.stateDateEnd = stateDateEnd
    }
}

extension SteamGameProgress.Achievement
{
    public init(achieved: Bool) {
        self.achieved = achieved
    }
}

extension SteamGameProgress.Stat
{
    public init(count: Double) {
        self.count = count
    }
}
