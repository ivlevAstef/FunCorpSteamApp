//
//  SteamDotaMatchData.swift
//  Storage
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

final class DotaMatchPlayerData: Object {
    @objc dynamic var _accountId: Int64 = 0
    @objc dynamic var _heroId: Int = 0
    @objc dynamic var _side: Int = 0
}

final class SteamDotaMatchData: Object {
    static func generatePrimaryKey(matchId: DotaMatchID, accountId: AccountID) -> String {
        return "\(matchId)_\(accountId)"
    }

    @objc dynamic var _primaryKey: String = ""
    @objc dynamic var _accountId: Int64 = 0
    @objc dynamic var _matchId: String = ""

    @objc dynamic var _startTime: Date = Date()
    @objc dynamic var _seqNumber: Int64 = 0
    @objc dynamic var _lobby: Int = -1

    let _players = List<DotaMatchPlayerData>()

    override static func primaryKey() -> String? {
        return "_primaryKey"
    }
}


extension SteamDotaMatchData
{
    // В теории тут можно обойтись без accountId и это будет более оптимальное хранение.
    // Но для этого надо больше запариваться, а смысла почти ноль - всеже мобила персональное устройство.
    convenience init(match: DotaMatch, accountId: AccountID) {
        self.init()

        _primaryKey = Self.generatePrimaryKey(matchId: match.matchId, accountId: accountId)
        _accountId = Int64(accountId)
        _matchId = "\(match.matchId)"
        _startTime = match.startTime
        _seqNumber = match.seqNumber
        _lobby = match.lobby?.toInt ?? -1
        _players.append(objectsIn: match.players.map { DotaMatchPlayerData(player: $0) })
    }

    var match: DotaMatch? {
        guard let matchId = DotaMatchID(_matchId) else {
            return nil
        }
        return DotaMatch(matchId: matchId,
                         startTime: _startTime,
                         seqNumber: _seqNumber,
                         lobby: DotaLobby(_lobby),
                         players: _players.map { $0.player })
    }
}

extension DotaMatchPlayerData
{
    convenience init(player: DotaMatch.Player) {
        self.init()

        _accountId = Int64(player.accountId)
        _heroId = Int(player.heroId)
        _side = player.side.toInt
    }

    var player: DotaMatch.Player {
        DotaMatch.Player(accountId: AccountID(_accountId),
                         heroId: DotaHeroID(_heroId),
                         side: DotaSide(_side) ?? .radiant)
    }
}
