//
//  SteamSessionData.swift
//  Storage
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Entities
import UseCases

final class SteamSessionsData: Object, LimitedUpdated {
    @objc dynamic var _steamId: String = ""

    let _sessions = List<SteamSessionData>()

    @objc dynamic var lastUpdateTime: Date = Date()

    override static func primaryKey() -> String? {
        return "_steamId"
    }
}

final class SteamSessionData: Object {
    @objc dynamic var _gameId: String = ""

    @objc dynamic var _name: String = ""
    @objc dynamic var _iconUrl: String? = nil
    @objc dynamic var _logoUrl: String? = nil

    @objc dynamic var _playtimeForever: Double = 0
    @objc dynamic var _playtime2weeks: Double = 0
}

extension SteamSessionsData {
    convenience init(sessions: [SteamSession], steamId: SteamID) {
        self.init()

        _steamId = "\(steamId)"
        _sessions.append(objectsIn: sessions.map { SteamSessionData(session: $0) })
    }

    var sessions: [SteamSession] {
        return Array(_sessions.compactMap { $0.session })
    }
}

extension SteamSessionData {
    convenience init(session: SteamSession) {
        self.init()
        _gameId = "\(session.gameInfo.gameId)"

        _name = session.gameInfo.name
        _iconUrl = session.gameInfo.iconUrl?.absoluteString
        _logoUrl = session.gameInfo.logoUrl?.absoluteString

        _playtimeForever = session.playtimeForever
        _playtime2weeks = session.playtime2weeks
    }

    var session: SteamSession? {
        guard let gameId = SteamGameID(_gameId) else {
            return nil
        }

        return SteamSession(
            gameInfo: SteamGameInfo(
                gameId: gameId,
                name: _name,
                iconUrl: _iconUrl.flatMap { URL(string: $0) },
                logoUrl: _logoUrl.flatMap { URL(string: $0) }
            ),
            playtimeForever: _playtimeForever,
            playtime2weeks: _playtime2weeks
        )
    }
}
