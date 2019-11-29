//
//  SteamProfileGameData.swift
//  Storage
//
//  Created by Alexander Ivlev on 29/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

final class SteamProfileGameData: Object, LimitedUpdated {
    static func generatePrimaryKey(steamId: SteamID, gameId: SteamGameID) -> String {
        return "\(steamId)_\(gameId)"
    }

    @objc dynamic var _steamId: String = ""
    @objc dynamic var _gameId: String = ""
    @objc dynamic var _primaryKey: String = ""

    @objc dynamic var _name: String = ""
    @objc dynamic var _iconUrl: String? = nil
    @objc dynamic var _logoUrl: String? = nil

    @objc dynamic var _playtimeForever: Double = 0
    @objc dynamic var _playtime2weeks: Double = 0

    @objc dynamic var lastUpdateTime: Date = Date()

    override static func primaryKey() -> String? {
        return "_primaryKey"
    }

    static override func indexedProperties() -> [String] {
        return ["_steamId", "_gameId"]
    }
}

extension SteamProfileGameData {
    convenience init(profileGameInfo game: SteamProfileGameInfo) {
        self.init()
        _steamId = "\(game.steamId)"
        _gameId = "\(game.gameInfo.gameId)"
        _primaryKey = Self.generatePrimaryKey(steamId: game.steamId, gameId: game.gameInfo.gameId)

        _name = game.gameInfo.name
        _iconUrl = game.gameInfo.iconUrl?.absoluteString
        _logoUrl = game.gameInfo.logoUrl?.absoluteString

        _playtimeForever = game.playtimeForever
        _playtime2weeks = game.playtime2weeks
    }

    var profileGameInfo: SteamProfileGameInfo? {
        guard let steamId = SteamID(_steamId), let gameId = SteamGameID(_gameId) else {
            return nil
        }

        return SteamProfileGameInfo(
            steamId: steamId,
            playtimeForever: _playtimeForever,
            playtime2weeks: _playtime2weeks,
            gameInfo: SteamGameInfo(
                gameId: gameId,
                name: _name,
                iconUrl: _iconUrl.flatMap { URL(string: $0) },
                logoUrl: _logoUrl.flatMap { URL(string: $0) }
        ))
    }
}
