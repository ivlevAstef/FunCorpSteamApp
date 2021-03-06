//
//  SteamDotaNetworkImpl.swift
//  Network
//
//  Created by Alexander Ivlev on 02/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Entities
import UseCases
import UseCasesContracts

final class SteamDotaNetworkImpl: SteamDotaNetwork
{
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func requestHistory(accountId: AccountID, count: UInt, heroId: Int?, from: DotaMatchID?, completion: @escaping (DotaMatchHistoryResult) -> Void) {
        var fields: [String: Any] = ["account_id": accountId, "matches_requested": count]
        if let heroId = heroId {
            fields["hero_id"] = heroId
        }
        if let from = from {
            fields["start_at_match_id"] = from
        }

        session.request(SteamRequest(
            interface: "IDOTA2Match_570",
            method: "GetMatchHistory",
            version: 1,
            fields: fields,
            parse: { Self.mapMatchesHistory($0) },
            completion: completion
        ))
    }

    func requestDetails(matchId: DotaMatchID, completion: @escaping (DotaMatchDetailsResult) -> Void) {
        session.request(SteamRequest(
            interface: "IDOTA2Match_570",
            method: "GetMatchDetails",
            version: 1,
            fields: ["match_id": matchId],
            parse: { Self.mapMatchDetails($0) },
            completion: completion
        ))
    }

    func requestHeroes(loc: SteamLocalization, completion: @escaping (DotaHeroesResult) -> Void) {
        session.request(SteamRequest(
            interface: "IEconDOTA2_570",
            method: "GetHeroes",
            version: 1,
            // Локализация возможно не рабочая, в силу того что код языка должен быть в другом формате.
            // Но на русский я так и не нашел перевода - возможно его и нет, поэтому пофиг
            fields: ["language": loc.toString],
            parse: { Self.mapHeroes($0) },
            completion: completion
        ))
    }

    // MARK: - matches history parser

    private static func mapMatchesHistory(_ response: MatchHistoryResponse) -> DotaMatchHistoryResult {
        if 1 == response.result.status {
            let matches = response.result.matches?.map(map) ?? []
            return .success(matches)
        } else if 15 == response.result.status {
            return .failure(.customError(SteamDotaError.notAllowed))
        } else {
            return .failure(.incorrectResponse)
        }
    }

    private static func map(_ match: MatchHistory) -> DotaMatch {
        return DotaMatch(
            matchId: DotaMatchID(match.match_id),
            startTime: match.start_time.unixTimeToDate,
            seqNumber: match.match_seq_num,
            lobby: map(match.lobby_type),
            players: match.players.map(map)
        )
    }

    private static func map(_ player: MatchHistoryPlayer) -> DotaMatch.Player {
        return DotaMatch.Player(accountId: AccountID(player.account_id ?? UInt32.max),
                                heroId: player.hero_id,
                                side: map(player.player_slot))
    }

    // MARK: - match details parser

    private static func mapMatchDetails(_ response: MatchDetailsResponse) -> DotaMatchDetailsResult {
        let details = map(response.result)
        return .success(details)
    }

    private static func map(_ details: MatchDetailsResult) -> DotaMatchDetails {
        return DotaMatchDetails(
            matchId: DotaMatchID(details.match_id),
            startTime: details.start_time.unixTimeToDate,
            seqNumber: details.match_seq_num,
            winSide: details.radiant_win ? .radiant : .dire,
            duration: TimeInterval(details.duration),
            lobby: map(details.lobby_type),
            players: details.players.map(map)
        )
    }

    private static func map(_ player: MatchDetailsPlayer) -> DotaMatchDetails.Player {
        return DotaMatchDetails.Player(
            accountId: AccountID(player.account_id ?? UInt32.max),
            heroId: player.hero_id,
            side: map(player.player_slot),
            items: [player.item_0, player.item_1, player.item_2, player.item_3, player.item_4, player.item_5] +
                [player.backpack_0, player.backpack_1, player.backpack_2],
            kills: player.kills,
            deaths: player.deaths,
            assists: player.assists,
            lastHits: player.last_hits,
            denies: player.denies,
            gpm: player.gold_per_min,
            xpm: player.xp_per_min,
            level: player.level
        )
    }

    // MARK: - heroes parser

    private static func mapHeroes(_ response: HeroesResponse) -> DotaHeroesResult {
        let heroes = response.result.heroes.map(map)
        return .success(heroes)
    }

    private static func map(_ hero: Hero) -> DotaHero {
        return DotaHero(id: hero.id,
                        name: hero.localized_name ?? localizeHeroName(hero.name),
                        iconURL: heroUrl(name: hero.name, suffix: "lg.png"),
                        iconFullHorizontalURL: heroUrl(name: hero.name, suffix: "full.png"),
                        iconFullVerticalURL: heroUrl(name: hero.name, suffix: "vert.jpg"))
    }

    private static func heroUrl(name: String, suffix: String) -> URL? {
        let name = name.replacingOccurrences(of: "npc_dota_hero_", with: "")
        let urlOfStr = "http://cdn.dota2.com/apps/dota2/images/heroes/\(name)_\(suffix)"

        return URL(string: urlOfStr)
    }

    private static func localizeHeroName(_ name: String) -> String {
        let name = name.replacingOccurrences(of: "npc_dota_hero_", with: "")
        return name.components(separatedBy: "_").map { $0.localizedCapitalized }.joined(separator: " ")
    }

    // MARK: - utility

    private static func map(_ playerSlot: UInt8) -> DotaSide {
        let sideNumber = playerSlot & 0b10000000
        switch sideNumber {
        case 0:
            return .radiant
        case 0b10000000:
            return .dire
        default:
            log.assert("Map player slot to side failed...")
            return .radiant
        }
    }

    private static func map(_ lobbyType: Int?) -> DotaLobby? {
        switch lobbyType {
        case 0: return .public
        case 1: return .practice
        case 2: return .tournament
        case 3: return .tutorial
        case 4: return .coopWithBots
        case 5: return .teamMatch
        case 6: return .soloQueue
        case 7: return .ranked
        case 8: return .soloMid1v1
        default:
            return nil
        }
    }
}

// MARK: - matches history data
private struct MatchHistoryResponse: Decodable {
    let result: MatchHistoryResult
}
private struct MatchHistoryResult: Decodable {
    let status: Int
    let matches: [MatchHistory]?
}
private struct MatchHistory: Decodable {
    let match_id: UInt64
    let start_time: Int64
    let lobby_type: Int?
    let match_seq_num: Int64
    let players: [MatchHistoryPlayer]
}
private struct MatchHistoryPlayer: Decodable {
    let account_id: UInt32? // Да его на самом деле может не быть... сам был в шоке
    let player_slot: UInt8
    let hero_id: UInt16
}

// MARK: - match details data
private struct MatchDetailsResponse: Decodable {
    let result: MatchDetailsResult
}
private struct MatchDetailsResult: Decodable {
    let match_id: UInt64
    let radiant_win: Bool
    let duration: Int
    let start_time: Int64
    let lobby_type: Int?
    let match_seq_num: Int64
    let players: [MatchDetailsPlayer]
}
private struct MatchDetailsPlayer: Decodable {
    let account_id: UInt32? // Да его на самом деле может не быть... сам был в шоке
    let player_slot: UInt8
    let hero_id: UInt16

    let item_0: Int
    let item_1: Int
    let item_2: Int
    let item_3: Int
    let item_4: Int
    let item_5: Int
    let backpack_0: Int
    let backpack_1: Int
    let backpack_2: Int

    let kills: UInt
    let deaths: UInt
    let assists: UInt

    let last_hits: UInt
    let denies: UInt

    let gold_per_min: UInt
    let xp_per_min: UInt
    let level: UInt
}

// MARK: - heroes data
private struct HeroesResponse: Decodable {
    let result: HeroesResult
}
private struct HeroesResult: Decodable {
    let heroes: [Hero]
}
private struct Hero: Decodable {
    let id: UInt16
    let name: String
    let localized_name: String?
}
