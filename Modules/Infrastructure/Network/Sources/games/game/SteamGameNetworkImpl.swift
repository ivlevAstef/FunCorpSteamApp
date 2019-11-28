//
//  SteamGameNetworkImpl.swift
//  Network
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

class SteamGameNetworkImpl: SteamGameNetwork
{
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func requestScheme(by gameId: SteamGameID, loc: SteamLocalization, completion: @escaping (SteamGameSchemeResult) -> Void) {
        session.request(SteamRequest(
            interface: "ISteamUserStats",
            method: "GetSchemaForGame",
            version: 2,
            fields: ["appid": gameId, "l": loc.toString],
            parse: { Self.mapScheme($0, with: gameId) },
            completion: completion
        ))
    }

    func requestGameProgress(by gameId: SteamGameID, steamId: SteamID, completion: @escaping (SteamGameProgressResult) -> Void) {
        session.request(SteamRequest(
            interface: "ISteamUserStats",
            method: "GetUserStatsForGame",
            version: 2,
            fields: ["appid": gameId, "steamId": steamId],
            parse: { Self.mapGameStats($0, with: gameId) },
            completion: completion
        ))
    }

    // MARK: - parse game scheme

    private static func mapScheme(_ response: SchemeResponse, with gameId: SteamGameID) -> SteamGameSchemeResult {
        let scheme = map(response.game, with: gameId)
        return .success(scheme)
    }

    private static func map(_ response: Scheme, with gameId: SteamGameID) -> SteamGameScheme {
        SteamGameScheme(gameId: gameId,
                        achivements: (response.availableGameStats.achievements ?? []).map(map),
                        stats: (response.availableGameStats.stats ?? []).map(map))
    }

    private static func map(_ response: SchemeGameAchievement) -> SteamGameScheme.Achivement {
        SteamGameScheme.Achivement(
            id: response.name,
            hidden: response.hidden != 0,
            localizedName: response.displayName,
            localizedDescription: response.description ?? "",
            iconUrl: URL(string: response.icon ?? ""),
            iconGrayUrl: URL(string: response.icongray ?? "")
        )
    }

    private static func map(_ response: SchemeGameStat) -> SteamGameScheme.Stat {
        SteamGameScheme.Stat(id: response.name, localizedName: response.displayName)
    }

    // MARK: - parse player game stats

    private static func mapGameStats(_ response: PlayerStatsResponse, with gameId: SteamGameID) -> SteamGameProgressResult {
        let gameProgress = map(response.playerstats, with: gameId)
        return .success(gameProgress)
    }

    private static func map(_ response: PlayerStats, with gameId: SteamGameID) -> SteamGameProgress {
        SteamGameProgress(
            gameId: gameId,
            achievements: map(response.achievements ?? []),
            stats: map(response.stats ?? []),
            stateDate: Date()
        )
    }

    private static func map(_ response: [PlayerAchievement]) -> [SteamAchievementID: SteamGameProgress.Achievement] {
        var result: [SteamAchievementID: SteamGameProgress.Achievement] = [:]
        for achievement in response {
            result[achievement.name] = SteamGameProgress.Achievement(achieved: achievement.achieved == 1)
        }
        return result
    }

    private static func map(_ response: [PlayerStat]) -> [SteamStatID: SteamGameProgress.Stat] {
        var result: [SteamStatID: SteamGameProgress.Stat] = [:]
        for stat in response {
            result[stat.name] = SteamGameProgress.Stat(count: stat.value)
        }
        return result
    }
}

// MARK: - game scheme

private struct SchemeResponse: Decodable {
    let game: Scheme
}
private struct Scheme: Decodable {
    let gameName: String
    let gameVersion: String

    let availableGameStats: SchemeGameStats
}
private struct SchemeGameStats: Decodable {
    let achievements: [SchemeGameAchievement]?
    let stats: [SchemeGameStat]?
}
private struct SchemeGameAchievement: Decodable {
    let name: String
    let defaultvalue: Double
    let displayName: String
    let hidden: Int
    let description: String?
    let icon: String?
    let icongray: String?
}
private struct SchemeGameStat: Decodable {
    let name: String
    let defaultvalue: Double
    let displayName: String
}

// MARK: - game user stats

private struct PlayerStatsResponse: Decodable {
    let playerstats: PlayerStats
}
private struct PlayerStats: Decodable {
    let steamID: String
    let gameName: String
    let achievements: [PlayerAchievement]?
    let stats: [PlayerStat]?
}
private struct PlayerAchievement: Decodable {
    let name: String
    let achieved: Int
}
private struct PlayerStat: Decodable {
    let name: String
    let value: Double
}
