//
//  SteamGameSchemeData.swift
//  Storage
//
//  Created by Alexander Ivlev on 29/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import Foundation
import RealmSwift
import Services

final class SteamGameSchemeData: Object, LimitedUpdated {
    static func generatePrimaryKey(gameId: SteamGameID, loc: SteamLocalization) -> String {
        return "\(gameId)_\(loc)"
    }

    @objc dynamic var _gameId: String = ""
    @objc dynamic var _primaryKey: String = ""

    let _achivements = List<SteamGameSchemeAchievementData>()
    let _stats = List<SteamGameSchemeStatData>()

    @objc dynamic var lastUpdateTime: Date = Date()

    override static func primaryKey() -> String? {
        return "_primaryKey"
    }
}

final class SteamGameSchemeAchievementData: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _hidden: Bool = false

    @objc dynamic var _localizedName: String = ""
    @objc dynamic var _localizedDescription: String = ""

    @objc dynamic var _iconUrl: String? = nil
    @objc dynamic var _iconGrayUrl: String? = nil
}

final class SteamGameSchemeStatData: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _localizedName: String = ""
}

extension SteamGameSchemeData {
    convenience init(scheme: SteamGameScheme, loc: SteamLocalization) {
        self.init()

        _gameId = "\(scheme.gameId)"
        _primaryKey = Self.generatePrimaryKey(gameId: scheme.gameId, loc: loc)

        _achivements.append(objectsIn: scheme.achivements.map { achievement in
            let data = SteamGameSchemeAchievementData()
            data._id = achievement.id
            data._hidden = achievement.hidden
            data._localizedName = achievement.localizedName
            data._localizedDescription = achievement.localizedDescription
            data._iconUrl = achievement.iconUrl?.absoluteString
            data._iconGrayUrl = achievement.iconGrayUrl?.absoluteString
            return data
        })

        _stats.append(objectsIn: scheme.stats.map { stat in
            let data = SteamGameSchemeStatData()
            data._id = stat.id
            data._localizedName = stat.localizedName
            return data
        })
    }

    var scheme: SteamGameScheme? {
        guard let gameId = SteamGameID(_gameId) else {
            return nil
        }

        let achivements = Array(_achivements.map { data in
            SteamGameScheme.Achivement(
                id: data._id,
                hidden: data._hidden,
                localizedName: data._localizedName,
                localizedDescription: data._localizedDescription,
                iconUrl: data._iconUrl.flatMap { URL(string: $0) },
                iconGrayUrl: data._iconGrayUrl.flatMap { URL(string: $0) }
            )
        })

        let stats = Array(_stats.map { data in
            SteamGameScheme.Stat(
                id: data._id,
                localizedName: data._localizedName
            )
        })

        return SteamGameScheme(gameId: gameId, achivements: achivements, stats: stats)
    }
}
