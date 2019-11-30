//
//  SteamProfileNetworkImpl.swift
//  Network
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

class SteamProfileNetworkImpl: SteamProfileNetwork
{
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func requestProfile(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void) {
        session.request(SteamRequest(
            interface: "ISteamUser",
            method: "GetPlayerSummaries",
            version: 2,
            fields: ["steamids": steamId],
            parse: { Self.mapPlayer($0, with: steamId) },
            completion: completion
        ))
    }

    func requestFriends(for steamId: SteamID, completion: @escaping (SteamFriendsResult) -> Void) {
         session.request(SteamRequest(
             interface: "ISteamUser",
             method: "GetFriendList",
             version: 1,
             fields: ["steamid": steamId],
             parse: { Self.mapFriends($0, with: steamId) },
             completion: completion
         ))
     }

    func requestGames(by steamId: SteamID, completion: @escaping (SteamProfileGamesInfoResult) -> Void) {
        // Вот такая несостыковочка - где-то это игры, а где-то приложения. Решил использовать App
        session.request(SteamRequest(
            interface: "IPlayerService",
            method: "GetOwnedGames",
            version: 1,
            fields: [
                "steamid": steamId,
                "include_appinfo": "true",
                "include_played_free_games": "true"
            ],
            parse: { Self.mapGames($0, with: steamId) },
            completion: completion
        ))
    }

    func requestGame(by steamId: SteamID, gameId: SteamGameID, completion: @escaping (SteamProfileGameInfoResult) -> Void) {
        // Вот такая несостыковочка - где-то это игры, а где-то приложения. Решил использовать App
        session.request(SteamRequest(
            interface: "IPlayerService",
            method: "GetOwnedGames",
            version: 1,
            fields: [
                "steamid": steamId,
                "include_appinfo": "true",
                "include_played_free_games": "true",
                "appids_filter": [gameId]
            ],
            parse: { Self.mapGame($0, with: steamId, gameId: gameId) },
            completion: completion
        ), useJson: true)
    }

    // MARK: - profile mapper

    private static func mapPlayer(_ response: Response<Players>, with steamId: SteamID) -> SteamProfileResult {
        guard let player = response.response.players.first else {
            return .failure(.incorrectResponse)
        }
        guard let responseSteamId = SteamID(player.steamid) else {
            return .failure(.incorrectResponse)
        }
        log.assert(responseSteamId == steamId, "request steam id not equal response")

        return .success(map(player, steamId: responseSteamId))
    }

    private static func map(_ result: Player, steamId: SteamID) -> SteamProfile {
        let visibilityState: SteamProfile.VisibilityState

        if 3 != result.communityvisibilitystate {
            visibilityState = .private
        } else {
            let state: SteamProfile.State
            switch result.personastate {
            case 0: state = .offline
            case 1: state = .online
            case 2: state = .busy
            case 3: state = .away
            case 4: state = .snooze
            case 5: state = .lookingToTrade
            case 6: state = .lookingToPlay
            default: state = .offline
            }

            visibilityState = .open(SteamProfile.OpenData(
                state: state,
                realName: result.realname,
                timeCreated: result.timecreated?.unixTimeToDate
            ))
        }

        return SteamProfile(
            steamId: steamId,
            profileURL: URL(string: result.profileurl),
            nickName: result.personaname,
            avatarURL: URL(string: result.avatarfull),
            mediumAvatarURL: URL(string: result.avatarmedium),
            lastlogoff: result.lastlogoff.unixTimeToDate,
            visibilityState: visibilityState
        )
    }

    // MARK: - profile games mapper

    private static func mapGames(_ response: Response<Games>, with steamId: SteamID) -> SteamProfileGamesInfoResult {
        let games = response.response.games.map { map($0, steamId: steamId) }
        return .success(games)
    }

    private static func mapGame(_ response: Response<Games>, with steamId: SteamID, gameId: SteamGameID) -> SteamProfileGameInfoResult {
        log.assert(response.response.games.count == 1, "received more game, but requested one")
        let foundGames = response.response.games.first(where:{ $0.appid == gameId })
        guard let game = foundGames.flatMap({ map($0, steamId: steamId) }) else {
            return .failure(.incorrectResponse)
        }
        return .success(game)
    }

    private static func map(_ result: Game, steamId: SteamID) -> SteamProfileGameInfo {
        let gameId = SteamGameID(result.appid)
        return SteamProfileGameInfo(
            steamId: steamId,
            playtimeForever: result.playtime_forever.flatMap { TimeInterval($0 * 60) } ?? 0,
            playtime2weeks: result.playtime_2weeks.flatMap { TimeInterval($0 * 60) } ?? 0,
            gameInfo: SteamGameInfo(
                gameId: gameId,
                name: result.name,
                iconUrl: result.img_icon_url.flatMap { Support.gameImageUrl(gameId: gameId, hash: $0) },
                logoUrl: result.img_logo_url.flatMap { Support.gameImageUrl(gameId: gameId, hash: $0) }
            )
        )
    }

    // MARK: - friends mapper
    private static func mapFriends(_ response: ResponseFriends, with steamId: SteamID) -> SteamFriendsResult {
        let friends = response.friendslist?.friends?.compactMap { map($0, with: steamId) } ?? []
        return .success(friends)
    }

    private static func map(_ friend: Friend, with steamId: SteamID) -> SteamFriend? {
        guard let friendSteamId = SteamID(friend.steamid) else {
            return nil
        }
        let friendSince = friend.friend_since?.unixTimeToDate
        return SteamFriend(ownerSteamId: steamId, steamId: friendSteamId, friendSince: friendSince)
    }
}

// MARK: - profile data

private struct Players: Decodable {
    let players: [Player]
}
private struct Player: Decodable {
    let steamid: String

    // Public

    let personaname: String
    let profileurl: String

    /// 1 - private, 3 - public
    let communityvisibilitystate: Int
    /// 0 - Offline, 1 - Online, 2 - Busy, 3 - Away, 4 - Snooze, 5 - looking to trade, 6 - looking to play.
    /// Always 0 if communityvisibilitystate = 3 private
    let personastate: Int

    /// Have community profile or not. 1	- have
    let profilestate: Int
    /// unix time
    let lastlogoff: Int64

    /// 32x32
    let avatar: String
    /// 64x64
    let avatarmedium: String
    /// 184x184
    let avatarfull: String

    // Private

    /// unix time
    let timecreated: Int64?

    let realname: String?
    /// if user in game then have game id
    //let gameid: Any?

    //let gameextrainfo: Any?
}

//            "primaryclanid":"103582791429521408",
//            "timecreated":1350317088,
//            "personastateflags":0,

//            "loccountrycode":"RU",
//            "locstatecode":"53",
//            "loccityid":41723

// MARK: - profile games data

private struct Games: Decodable {
    let game_count: Int
    let games: [Game]
}
private struct Game: Decodable {
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

// MARK: - friends data
private struct ResponseFriends: Decodable {
    let friendslist: FriendsList?
}

private struct FriendsList: Decodable {
    let friends: [Friend]?
}

private struct Friend: Decodable {
    let steamid: String
    let relationship: String?
    let friend_since: Int64?
}
