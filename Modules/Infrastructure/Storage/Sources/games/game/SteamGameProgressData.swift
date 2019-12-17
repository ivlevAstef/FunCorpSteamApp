//
//  SteamGameProgressData.swift
//  Storage
//
//  Created by Alexander Ivlev on 29/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Entities
import UseCases

final class SteamLastGameProgressData: Object {
    static func generatePrimaryKey(steamId: SteamID, gameId: SteamGameID) -> String {
        return "\(steamId)_\(gameId)"
    }

    @objc dynamic var _primaryKey: String = ""
    @objc dynamic var _order: Int64 = 0

    override static func primaryKey() -> String? {
        return "_primaryKey"
    }
}

final class SteamGameProgressData: Object, LimitedUpdated, Ordered {
    static func generatePrimaryKey(steamId: SteamID, gameId: SteamGameID, order: Int64) -> String {
        return "\(steamId)_\(gameId)_\(order)"
    }

    @objc dynamic var _steamId: String = ""
    @objc dynamic var _gameId: String = ""
    @objc dynamic var _primaryKey: String = ""

    @objc dynamic var _stateDateBegin: Date = Date()
    @objc dynamic var _stateDateEnd: Date = Date()

    let _achivements = List<SteamGameProgressAchievementData>()
    let _stats = List<SteamGameProgressStatData>()

    @objc dynamic var order: Int64 = 0
    @objc dynamic var lastUpdateTime: Date = Date()

    override static func primaryKey() -> String? {
        return "_primaryKey"
    }
}

final class SteamGameProgressAchievementData: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _achieved: Bool = false
}

final class SteamGameProgressStatData: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _count: Double = 0.0
}

extension SteamGameProgressData
{
    convenience init(gameProgress: SteamGameProgress, order: Int64, steamId: SteamID) {
        self.init()

        self.order = order
        _steamId = "\(steamId)"
        _gameId = "\(gameProgress.gameId)"
        _primaryKey = Self.generatePrimaryKey(steamId: steamId, gameId: gameProgress.gameId, order: order)

        _stateDateBegin = gameProgress.stateDateBegin
        _stateDateEnd = gameProgress.stateDateEnd

        _achivements.append(objectsIn: gameProgress.achievements.map { id, achievement in
            let data = SteamGameProgressAchievementData()
            data._id = id
            data._achieved = achievement.achieved
            return data
        })

        _stats.append(objectsIn: gameProgress.stats.map { id, stat in
            let data = SteamGameProgressStatData()
            data._id = id
            data._count = stat.count
            return data
        })
    }

    var gameProgress: SteamGameProgress? {
        guard let gameId = SteamGameID(_gameId) else {
            return nil
        }

        var achievements: [SteamAchievementID: SteamGameProgress.Achievement] = [:]
        for data in _achivements {
            achievements[data._id] = SteamGameProgress.Achievement(achieved: data._achieved)
        }

        var stats: [SteamStatID: SteamGameProgress.Stat] = [:]
        for data in _stats {
            stats[data._id] = SteamGameProgress.Stat(count: data._count)
        }

        return SteamGameProgress(
            gameId: gameId,
            achievements: achievements,
            stats: stats,
            stateDateBegin: _stateDateBegin,
            stateDateEnd: _stateDateEnd)
    }
}
