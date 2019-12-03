//
//  SteamDotaMatchDetailsData.swift
//  Storage
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

final class DotaMatchDetailsPlayerItemsData: Object {
    @objc dynamic var _itemId: Int = 0
}

final class DotaMatchDetailsPlayerData: Object {
    @objc dynamic var _accountId: Int64 = 0
    @objc dynamic var _heroId: Int = 0
    @objc dynamic var _side: Int = 0
    
    let _items = List<DotaMatchDetailsPlayerItemsData>()

    @objc dynamic var _kills: Int = 0
    @objc dynamic var _deaths: Int = 0
    @objc dynamic var _assists: Int = 0
    @objc dynamic var _lastHits: Int = 0
    @objc dynamic var _denies: Int = 0

    @objc dynamic var _gpm: Int = 0
    @objc dynamic var _xpm: Int = 0

    @objc dynamic var _level: Int = 0
}

final class SteamDotaMatchDetailsData: Object {
    static func generatePrimaryKey(matchId: DotaMatchID, accountId: AccountID) -> String {
        return "\(matchId)_\(accountId)"
    }

    @objc dynamic var _primaryKey: String = ""
    @objc dynamic var _accountId: Int64 = 0
    @objc dynamic var _matchId: String = ""

    @objc dynamic var _startTime: Date = Date()
    @objc dynamic var _seqNumber: Int64 = 0
    @objc dynamic var _lobby: Int = -1

    @objc dynamic var _winSide: Int = 0
    @objc dynamic var _duration: Double = 0


    let _players = List<DotaMatchDetailsPlayerData>()

    override static func primaryKey() -> String? {
        return "_primaryKey"
    }
}


extension SteamDotaMatchDetailsData
{
    // В теории тут можно обойтись без accountId и это будет более оптимальное хранение.
    // Но для этого надо больше запариваться, а смысла почти ноль - всеже мобила персональное устройство.
    convenience init(match: DotaMatchDetails, accountId: AccountID) {
        self.init()

        _primaryKey = Self.generatePrimaryKey(matchId: match.matchId, accountId: accountId)
        _accountId = Int64(accountId)
        _matchId = "\(match.matchId)"
        _startTime = match.startTime
        _seqNumber = match.seqNumber
        _lobby = match.lobby?.toInt ?? -1
        _winSide = match.winSide.toInt
        _duration = match.duration
        _players.append(objectsIn: match.players.map { DotaMatchDetailsPlayerData(player: $0) })
    }

    var matchDetails: DotaMatchDetails? {
        guard let matchId = DotaMatchID(_matchId) else {
            return nil
        }

        return DotaMatchDetails(
            matchId: matchId,
            startTime: _startTime,
            seqNumber: _seqNumber,
            winSide: DotaSide(_winSide) ?? .radiant,
            duration: _duration,
            lobby: DotaLobby(_lobby),
            players: _players.map { $0.player }
        )
    }
}

extension DotaMatchDetailsPlayerData
{
    convenience init(player: DotaMatchDetails.Player) {
        self.init()
        _accountId = Int64(player.accountId)
        _heroId = Int(player.heroId)
        _side = player.side.toInt

        _items.append(objectsIn: player.items.map {
            let item = DotaMatchDetailsPlayerItemsData()
            item._itemId = $0
            return item
        })

        _kills = Int(player.kills)
        _deaths = Int(player.deaths)
        _assists = Int(player.assists)
        _lastHits = Int(player.lastHits)
        _denies = Int(player.denies)

        _gpm = Int(player.gpm)
        _xpm = Int(player.xpm)

        _level = Int(player.level)
    }

    var player: DotaMatchDetails.Player {
        return DotaMatchDetails.Player(
            accountId: AccountID(_accountId),
            heroId: DotaHeroID(_heroId),
            side: DotaSide(_side) ?? .radiant,
            items: _items.map { $0._itemId },
            kills: UInt(_kills),
            deaths: UInt(_deaths),
            assists: UInt(_assists),
            lastHits: UInt(_lastHits),
            denies: UInt(_denies),
            gpm: UInt(_gpm),
            xpm: UInt(_xpm),
            level: UInt(_level)
        )
    }
}
