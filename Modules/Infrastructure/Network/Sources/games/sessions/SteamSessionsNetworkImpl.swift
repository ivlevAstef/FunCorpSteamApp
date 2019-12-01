//
//  SteamSessionsNetworkImpl.swift
//  Network
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class SteamSessionsNetworkImpl: SteamSessionsNetwork
{
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func requestSessions(for steamId: SteamID, completion: @escaping (SteamSessionsResult) -> Void) {
        session.request(SteamRequest(
            interface: "IPlayerService",
            method: "GetRecentlyPlayedGames",
            version: 1,
            fields: ["steamid": steamId, "count": 0],
            parse: { Self.mapSessions($0) },
            completion: completion
        ))
    }

    // MARK: - sessions

    private static func mapSessions(_ response: Response<SessionsInfo>) -> SteamSessionsResult {
        let games = response.response.games.map { map($0) }
        return .success(games)
    }

    private static func map(_ game: SessionGame) -> SteamSession {
        let gameId = SteamGameID(game.appid)
        return SteamSession(
            gameInfo: SteamGameInfo(
                gameId: gameId,
                name: game.name,
                iconUrl: game.img_icon_url.flatMap { Support.gameImageUrl(gameId: gameId, hash: $0) },
                logoUrl: game.img_logo_url.flatMap { Support.gameImageUrl(gameId: gameId, hash: $0) }
            ),
            playtimeForever: game.playtime_forever.flatMap { TimeInterval($0 * 60) } ?? 0,
            playtime2weeks: game.playtime_2weeks.flatMap { TimeInterval($0 * 60) } ?? 0
        )
    }
}

private struct SessionsInfo: Decodable {
    let total_count: Int
    let games: [SessionGame]
}

private struct SessionGame: Decodable {
    let appid: SteamGameID
    let name: String
    /// it's image hash
    let img_icon_url: String?
    /// it's image hash
    let img_logo_url: String?

    /// summary in game time
    let playtime_forever: Int64?
    /// summary in game time
    let playtime_2weeks: Int64?
}
